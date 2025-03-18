import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vintiora/core/config/environment_config.dart';
import 'package:vintiora/core/di/di_setup.dart';
import 'package:vintiora/core/router/nav.dart';
import 'package:vintiora/core/storage/local_storage.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/core/utils/firebase_util.dart';
import 'package:vintiora/core/utils/notification_util.dart';
import 'package:vintiora/core/utils/utils.dart';
import 'package:vintiora/firebase_options.dart';

class Config {
  static Future<void> load({void Function(dynamic error)? done}) async {
    try {
      // Initialize dependencies concurrently where possible
      await Hive.initFlutter();
      await Future.wait([
        EnvironmentConfig.load(ConfigMode.dev),
        _initializeStorage(),
        LocalStorage.init(Constants.dbName),
        // _requestPermissions(), //TODO: uncomment
        _initNotification(),
      ]);

      Stripe.publishableKey = Constants.stripePublishableKey;
      setupDependencies();

      // await simulateError();

      done?.call(null);
    } catch (e) {
      // logger.e('Error loading config: $e');
      done?.call(e);
    }
  }

  static Future<void> _initializeStorage() async {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: isWeb ? HydratedStorageDirectory.web : HydratedStorageDirectory((await getTemporaryDirectory()).path),
    );
  }

  static Future<void> _initNotification() async {
    if (!isWindows) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    await NotificationUtil.initNotification();
    if (!isWindows) {
      await FirebaseUtil.configureFirebaseMessaging();
    }
  }

  static Future<void> _requestPermissions() async {
    await [
      Permission.location,
      Permission.notification,
    ].request();
  }

  static Future<void> loadEvents([BuildContext? buildContext]) async {
    BuildContext context = buildContext ?? navContext!;

    final List<Future<void>> blocOperations = [
      /*_waitForBlocCompletion<DashboardBloc, DashboardState>(
        context: context,
        action: (bloc) => bloc.add(LoadDashboardData()),
        condition: (state) => state.status != DashboardStatus.loading,
      ),
      _waitForBlocCompletion<UserBloc, UserState>(
        context: context,
        action: (bloc) => bloc.add(LoadUsers()),
        condition: (state) => state.status != UserStatus.loading,
      ),
      _waitForBlocCompletion<VendorBloc, VendorState>(
        context: context,
        action: (bloc) => bloc.add(LoadVendors()),
        condition: (state) => state.status != VendorStatus.loading,
      ),
      _waitForBlocCompletion<ActivityBloc, ActivityState>(
        context: context,
        action: (bloc) => bloc.add(LoadActivities()),
        condition: (state) => state.status != ActivityStatus.loading,
      ),*/
    ];

    blocOperations.addAll([]);

    // Wait for all bloc operations to complete
    await Future.wait(blocOperations);
  }

  // Helper method to wait for a bloc operation to complete
  static Future<void> _waitForBlocCompletion<B extends BlocBase<S>, S>({
    required BuildContext context,
    required void Function(B bloc) action,
    required bool Function(S state) condition,
  }) {
    final completer = Completer<void>();
    final bloc = BlocProvider.of<B>(context);
    late StreamSubscription<S> subscription;

    subscription = bloc.stream.listen((state) {
      if (condition(state)) {
        subscription.cancel();
        completer.complete();
      }
    });

    action(bloc);
    return completer.future;
  }

  static Future<void> simulateError() async {
    final file = File('non_existent_file.txt');
    await file.readAsString();
  }
}
