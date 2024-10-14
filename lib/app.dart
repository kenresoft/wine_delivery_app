import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wine_delivery_app/utils/extensions.dart';

import 'bloc/network/network_bloc.dart';
import 'bloc/theme/theme_cubit.dart';
import 'utils/enums.dart';
import 'utils/environment_config.dart';
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

  @override
  void initState() {
    super.initState();
    _currentError = widget.initialError;
    WidgetsBinding.instance.addObserver(this);
    context.read<NetworkBloc>().add(StartNetworkListening());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
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

  @override
  Widget build(BuildContext context) {
    final BuildContext currentContext = context;
    return ScreenUtilInit(
      designSize: const Size(360, 825),
      minTextAdapt: true,
      ensureScreenSize: true,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            BlocListener<NetworkBloc, NetworkState>(
              listener: (context, state) {
                if (state is BannerVisible) {
                  // state.message.toast;
                }
              },
              child: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, state) {
                  return buildMaterialApp(currentContext, state);
                },
              ),
            ),
            /*BlocBuilder<NetworkBloc, NetworkState>(
              builder: (context, state) {
                if (state is BannerVisible) {
                  return ConnectionBanner(
                    message: state.message,
                    isVisible: true,
                    style: state.style,
                    onClose: () => context.read<NetworkBloc>().add(const HideBanner()),
                  );
                } else if (state is BannerHidden) {
                  return const SizedBox.shrink();
                }
                return const SizedBox.shrink();
              },
            ),*/
          ],
        ),
      ),
    );
  }

  MaterialApp buildMaterialApp(BuildContext mainContext, ThemeMode themeMode) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme(mainContext).themeData,
      darkTheme: AppTheme(mainContext).themeData,
      themeMode: themeMode,
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
                      setState(() => _currentError = null);
                      Navigator.of(mainContext).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const SplashScreen(),
                        ),
                      );
                    }
                  } catch (error) {
                    // Handle any initialization errors
                    logger.e("Error during initialization: $error");
                    if (mounted) {
                      setState(() => _currentError = error);
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
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Object?>('_currentError', _currentError));
  }
}
