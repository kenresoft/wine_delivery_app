import 'dart:async';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wine_delivery_app/views/connection_banner.dart';
import 'package:wine_delivery_app/views/connection_banner_style.dart';

import 'bloc/providers.dart';
import 'utils/enums.dart';
import 'utils/environment_config.dart';
import 'utils/internet_connection_checker.dart';
import 'utils/internet_connection_result.dart';
import 'utils/themes.dart';
import 'utils/utils.dart';
import 'views/admin/oder_management_page.dart';
import 'views/error_screen.dart';
import 'views/home/home.dart';
import 'views/onboarding/splash_screen.dart';
import 'views/product/cart/shopping_cart.dart';
import 'views/product/category/products_category_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.initialError});

  final Object? initialError;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Object? _currentError;
  late StreamSubscription<InternetConnectionResult> _connectionSubscription;
  bool _isBannerVisible = false;
  String _connectionMessage = "Checking connection...";
  ConnectionBannerStyle _bannerStyle = ConnectionBannerStyle.offline();

  @override
  void initState() {
    super.initState();
    _currentError = widget.initialError;
    WidgetsBinding.instance.addObserver(this);

    // Start listening to connection changes globally
    internetConnectionChecker.startListening();

    // Subscribe to the connection stream globally
    subscribeToConnection();
  }

  void showOfflineBanner() {
    setState(() {
      _connectionMessage = "No internet connection!";
      _bannerStyle = ConnectionBannerStyle.offline();
      _isBannerVisible = true;
    });
  }

  void showOnlineBanner() {
    setState(() {
      _connectionMessage = 'Internet connection is available';
      _bannerStyle = ConnectionBannerStyle.online();
      _isBannerVisible = true;
    });
  }

  void hideBanner() {
    setState(() {
      _isBannerVisible = false;
    });
  }

  void subscribeToConnection() {
    // Subscribe to the connection stream globally
    _connectionSubscription = internetConnectionChecker.connectionStream.listen((result) {
      if (result.dnsSuccess && result.socketSuccess && result.httpSuccess) {
        showOnlineBanner();
      } else {
        showOfflineBanner();
      }

      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          hideBanner();
        }
      });

      logger.d(result.failureReason);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !internetConnectionChecker.isListening) {
      internetConnectionChecker.startListening();
    } else if ((state == AppLifecycleState.paused || state == AppLifecycleState.detached) && internetConnectionChecker.isListening) {
      internetConnectionChecker.stopListening();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectionSubscription.cancel(); // Cancel the subscription when disposing
    internetConnectionChecker.dispose(); // Clean up the connection checker
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BuildContext currentContext = context;
    return ScreenUtilInit(
      designSize: const Size(360, 825),
      minTextAdapt: true,
      ensureScreenSize: true,
      child: MultiBlocProvider(
        providers: Providers.blocProviders,
        child: Directionality(
          textDirection: TextDirection.ltr, // Add this
          child: Stack(
            children: [
              MaterialApp(
                title: 'Flutter Demo',
                debugShowCheckedModeBanner: false,
                theme: AppTheme().themeData,
                // darkTheme: AppTheme().darkThemeData,
                themeMode: ThemeMode.system,
                routes: {
                  '/': condition(
                    widget.initialError != null,
                    (context) => ErrorScreen(
                      message: "Initialization failed: ${widget.initialError}",
                      errorType: ErrorType.initialization,
                      onRetry: () async {
                        try {
                          // Load configuration and services
                          await SharedPreferencesService.init();
                          await EnvironmentConfig.load(ConfigMode.dev);

                          // If successful, clear the error and navigate to the home
                          if (mounted) {
                            setState(() {
                              _currentError = null; // Reset the error
                            });
                            Navigator.of(currentContext).pushReplacement(
                              // Use the captured context
                              MaterialPageRoute(
                                builder: (context) {
                                  return const SplashScreen();
                                },
                              ),
                            );
                          }
                        } catch (error) {
                          // Handle any initialization errors
                          logger.e("Error during initialization: $error");
                          if (mounted) {
                            setState(() {
                              _currentError = error; // Update error state
                            });
                          }
                        }
                      },
                    ),
                    (context) => const SplashScreen(),
                  ),
                  '/cart_page': (context) => const ShoppingCartScreen(),
                  '/home': (context) => const Home(),
                  '/order_management_page': (context) => const OrderManagementPage(),
                  '/category': (context) => const CategoryScreen(),
                },
              ),
              // Connection banner widget displayed on top of the screen
              ConnectionBanner(
                message: _connectionMessage,
                isVisible: _isBannerVisible,
                // backgroundColor: bannerColor,
                style: _bannerStyle,
                onClose: () {
                  setState(() {
                    _isBannerVisible = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Object?>('_currentError', _currentError));
  }
}