import 'dart:async';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wine_delivery_app/views/connection_banner.dart';

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

void main() async {
  // Run the app in a guarded zone for uncaught errors
  runZonedGuarded(() async {
    // Ensure that the Flutter binding is initialized in the same zone as runApp
    WidgetsFlutterBinding.ensureInitialized();

    // Capture any Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      logger.e(
        "Flutter Error: ${details.exceptionAsString()}",
        stackTrace: details.stack,
      );
    };
    try {
      // Load configuration and services after binding initialization
      await SharedPreferencesService.init(
        enableCaching: true,
        cacheOptions: const SharedPreferencesWithCacheOptions()
      );
      await EnvironmentConfig.load(ConfigMode.dev);
      // Stripe.publishableKey = Constants.stripePublishableKey;

      logger.d('No error during initialization');
      runApp(const MyApp());
    } catch (error) {
      // Handle any initialization errors
      logger.e("Error during initialization: $error");
      runApp(MyApp(initialError: error)); // Pass the error to MyApp
    }
  }, (error, stack) {
    // Handle uncaught errors
    logger.e("Unhandled error: $error", stackTrace: stack);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.initialError});

  final Object? initialError;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Object? _currentError;
  late StreamSubscription<InternetConnectionResult> _connectionSubscription;
  bool internetStatus = false;
  bool isBannerVisible = false;
  String connectionMessage = "Checking connection...";

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Color bannerColor = Colors.red; // Default color for offline status

  @override
  void initState() {
    super.initState();

    // SharedPreferencesService.remove('promoCode');
    // SharedPreferencesService.clear();
    //internetStatus = false;

    // logger.w('Check: ${SharedPreferencesService.instance}');

    _currentError = widget.initialError;
    WidgetsBinding.instance.addObserver(this);

    // Initialize local notifications
    /*const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);*/

    // Start listening to connection changes globally
    internetConnectionChecker.startListening();

    // Subscribe to the connection stream globally
    _connectionSubscription = internetConnectionChecker.connectionStream.listen((result) {
      String message;
      bool status;
      Color bannerBgColor;
      if (result.dnsSuccess && result.socketSuccess && result.httpSuccess) {
        message = 'Internet connection is available';
        bannerBgColor = Colors.green; // Green for online status
        status = true;
      } else {
        message = 'Internet connection is down: ${result.failureReason}';
        bannerBgColor = Colors.red; // Red for offline status
        status = false;
      }

      setState(() {
        connectionMessage = message;
        internetStatus = status;
        bannerColor = bannerBgColor;
        isBannerVisible = true;
      });

      // Automatically hide the banner after 3 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            isBannerVisible = false;
          });
        }
      });

      // Show notification
      // _showNotification(message);

      logger.d(message);
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

  /*Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'connection_channel',
      'Connection Status',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Connection Status',
      message,
      notificationDetails,
    );
  }*/

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
              ConnectionBannerWidget(
                message: connectionMessage,
                isVisible: isBannerVisible,
                backgroundColor: bannerColor,
                onClose: () {
                  setState(() {
                    isBannerVisible = false;
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
