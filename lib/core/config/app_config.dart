import 'dart:async';
import 'dart:io';

import 'package:extensionresoft/extensionresoft.dart';
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
import 'package:vintiora/features/cart/presentation/bloc/cart_old/cart_bloc.dart' as c;
import 'package:vintiora/features/flash_sale/presentation/blocs/active_flash_sales/active_flash_sales_bloc.dart';
import 'package:vintiora/features/order/presentation/bloc/shipment/shipment_bloc.dart';
import 'package:vintiora/features/product/presentation/bloc/favorite/favs_bloc.dart';
import 'package:vintiora/features/product/presentation/bloc/product/product_bloc.dart';
import 'package:vintiora/features/user/presentation/bloc/profile/profile_bloc.dart';
import 'package:vintiora/firebase_options.dart';

import '../../features/cart/presentation/bloc/cart/cart_bloc.dart';

class Config {
  static Future<void> load({void Function(dynamic error)? onComplete}) async {
    try {
      // Initialize dependencies concurrently where possible
      await Hive.initFlutter();
      await Future.wait([
        EnvironmentConfig.load(ConfigMode.dev),
        _initializeStorage(),
        LocalStorage.init(Constants.dbName),
        // _requestPermissions(), //TODO: uncomment when needed
        _initNotification(),
      ]);

      Stripe.publishableKey = Constants.stripePublishableKey;
      setupDependencies();

      onComplete?.call(null);
    } catch (e, stackTrace) {
      logger.e('Error loading config', error: e, stackTrace: stackTrace);
      onComplete?.call(e);
      rethrow;
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

  static Future<void> loadMainEvents([BuildContext? buildContext]) async {
    final context = buildContext ?? navContext!;
    if (!context.mounted) return;

    await Future.wait([
      _waitForBlocCompletion<ProductBloc, ProductState>(
        context: context,
        action: (bloc) => bloc.add(LoadAllProducts()),
        condition: (state) => state.status != ProductsStatus.loading,
      ),
      _waitForBlocCompletion<ProductBloc, ProductState>(
        context: context,
        action: (bloc) => bloc.add(LoadNewArrivals()),
        condition: (state) => state.status != ProductsStatus.loading,
      ),
      _waitForBlocCompletion<ProductBloc, ProductState>(
        context: context,
        action: (bloc) => bloc.add(LoadPopularProducts(days: 90, limit: 50)),
        condition: (state) => state.status != ProductsStatus.loading,
      ),
      _waitForBlocCompletion<ActiveFlashSalesBloc, ActiveFlashSalesState>(
        context: context,
        action: (bloc) => bloc.add(LoadActiveFlashSales()),
        condition: (state) => state.status != ActiveFlashSalesStatus.loading,
      ),
      _waitForBlocCompletion<ProfileBloc, ProfileState>(
        context: context,
        action: (bloc) => bloc.add(const ProfileFetch()),
        condition: (state) => state.status != ProfileStatus.loading,
      ),
    ]);
  }

  static Future<void> loadEvents({BuildContext? context, bool loadOnlyMainEvents = false}) async {
    final ctx = context ?? navContext!;
    if (!ctx.mounted) return;

    // Load events based on the flag
    if (loadOnlyMainEvents) {
      await loadMainEvents();
    } else {
      await Future.wait([
        loadMainEvents(ctx),
        _waitForBlocCompletion<FavsBloc, FavsState>(
          context: ctx,
          action: (bloc) => bloc.add(LoadFavs()),
          condition: (state) => state != null,
        ),
        _waitForBlocCompletion<ShipmentBloc, ShipmentState>(
          context: ctx,
          action: (bloc) => bloc.add(GetShipmentDetails()),
          condition: (state) => state != null,
        ),
        _waitForBlocCompletion<c.CartBloc, c.CartState>(
          context: ctx,
          action: (bloc) => bloc.add(c.GetCartItems()),
          condition: (state) => state.status != c.CartStatus.loading,
        ),
        _waitForBlocCompletion<CartBloc, CartState>(
          context: ctx,
          action: (bloc) => bloc.add(GetCartEvent()),
          condition: (state) => state.status != CartStatus.loading,
        ),
      ]);
    }

    logger.w('All config events loaded');
  }

  // Helper method to wait for a bloc operation to complete
  static Future<void> _waitForBlocCompletion<B extends BlocBase<S>, S>({
    required BuildContext context,
    required void Function(B bloc) action,
    required bool Function(S state) condition,
  }) async {
    if (!context.mounted) return;

    final completer = Completer<void>();
    final bloc = BlocProvider.of<B>(context);
    late StreamSubscription<S> subscription;

    subscription = bloc.stream.listen((state) {
      if (condition(state)) {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    action(bloc);
    await completer.future;
  }

  static Future<void> simulateError() async {
    try {
      final file = File('non_existent_file.txt');
      await file.readAsString();
    } catch (e, stackTrace) {
      logger.e('Simulated error', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
