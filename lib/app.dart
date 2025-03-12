import 'package:app_links/app_links.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintiora/core/config/app_config.dart';
import 'package:vintiora/core/network/bloc/network_bloc.dart';
import 'package:vintiora/core/router/app_router.dart';
import 'package:vintiora/core/router/nav.dart';
import 'package:vintiora/core/router/routes.dart';
import 'package:vintiora/core/storage/preferences.dart';
import 'package:vintiora/core/theme/app_theme.dart';
import 'package:vintiora/core/theme/bloc/theme_bloc.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/product/data/repositories/product_repository.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.initializationError});

  final Object? initializationError;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Object? _currentError;
  bool _networkListeningStarted = false;
  final _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    _currentError = widget.initializationError;
    WidgetsBinding.instance.addObserver(this);
    _initDeepLinkListener();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_networkListeningStarted) {
      // Start listening to the network only once
      context.read<NetworkBloc>().add(StartNetworkListening());
      _networkListeningStarted = true;
    }
    eventsLoadedBefore = false;
    Config.loadEvents(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _manageNetworkAndLifecycleState(state);
  }

  void _manageNetworkAndLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // context.read<NetworkBloc>().add(GetCurrentNetworkStatus());
      context.read<NetworkBloc>().add(StartNetworkListening());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    context.read<NetworkBloc>().close();
    super.dispose();
  }

  void handleError(Object? error) {
    if (mounted) {
      setState(() => _currentError = error);
    }
  }

  Future<void> retryInitialization() async {
    try {
      await Config.load(
        done: (error) {
          if (error == null && mounted) {
            setState(() => _currentError = null);
            Nav.pushReplace(Routes.splash);
          } else {
            handleError(error);
          }
        },
      );
    } catch (error) {
      logger.e("Error during initialization: $error");
      handleError(error);
    }
  }

  Future<void> _initDeepLinkListener() async {
    _appLinks.uriLinkStream.listen((Uri? uri) async {
      if (uri != null) {
        await _handleDeepLink(uri.toString());
      }
    }, onError: (error) {
      logger.e('Error in deep link: $error');
    });

    // To handle the initial link (if the app was opened via a link)
    Uri? initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      await _handleDeepLink(initialUri.toString());
    }
  }

  Future<void> _handleDeepLink(String link) async {
    Uri uri = Uri.parse(link);
    logger.d('Deep link: $uri');

    if (uri.pathSegments.isNotEmpty) {
      if (uri.pathSegments[0] == 'product') {
        final productId = uri.pathSegments[1];
        final product = await productRepository.getProductById(productId);
        Nav.push(Routes.productDetails, arguments: product);
      } else if (uri.pathSegments[0] == 'cart') {
        logger.i('cart');
        Nav.push(Routes.cart);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final BuildContext currentContext = context;
    return ScreenUtilInit(
      designSize: const Size(360, 825),
      minTextAdapt: true,
      ensureScreenSize: true,
      builder: (context, child) {
        return child!;
      },
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: GestureDetector(
          onTap: () => primaryFocus?.unfocus(),
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return buildMaterialApp(currentContext, state);
            },
          ),
        ),
      ),
    );
  }

  MaterialApp buildMaterialApp(BuildContext mainContext, ThemeState themeState) {
    return MaterialApp(
      title: Constants.appName,
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      themeMode: themeState.themeMode,
      navigatorKey: Nav.navigatorKey,
      navigatorObservers: [Nav.routeObserver, Nav.stateObserver],
      initialRoute: _currentError == null ? Routes.splash.path : Routes.error.path,
      onGenerateRoute: (settings) {
        return AppRouter().generateRoute(
          settings,
          error: _currentError,
          onRetry: retryInitialization,
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Object?>('_currentError', _currentError));
  }
}
