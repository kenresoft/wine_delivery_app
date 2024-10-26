import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc/network/network_bloc.dart';
import 'bloc/theme/theme_cubit.dart';
import 'utils/helpers.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.initialError});

  final Object? initialError;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Object? _currentError;
  bool _networkListeningStarted = false;

  @override
  void initState() {
    super.initState();
    _currentError = widget.initialError;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_networkListeningStarted) {
      // Start listening to the network only once
      context.read<NetworkBloc>().add(StartNetworkListening());
      _networkListeningStarted = true;
    }
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
      await loadConfig(
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
          ],
        ),
      ),
    );
  }

  MaterialApp buildMaterialApp(BuildContext mainContext, ThemeMode themeMode) {
    final themeData = _currentError == null ? color(mainContext).themeData : ThemeData.light();

    return MaterialApp(
      title: 'Vintiora',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      darkTheme: themeData,
      themeMode: _currentError == null ? themeMode : ThemeMode.light,
      navigatorKey: Nav.navigatorKey,
      navigatorObservers: [Nav.routeObserver],
      initialRoute: _currentError == null ? Routes.splash : Routes.error,
      onGenerateRoute: (settings) {
        return AppRouter().generateRoute(
          settings,
          error: _currentError,
          onRetry: retryInitialization,
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Object?>('_currentError', _currentError));
  }
}
