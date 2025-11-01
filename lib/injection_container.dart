import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'core/config/app_config.dart';
import 'features/addresses/domain/services/location_autocomplete_service.dart';
import 'features/addresses/data/services/mock_location_autocomplete_service.dart';
import 'features/addresses/data/services/google_places_autocomplete_service.dart';
// import 'package:connectivity_plus/connectivity_plus.dart'; // Temporarily disabled

import 'core/utils/network_info.dart';
import 'features/splash/data/datasources/splash_local_data_source.dart';
import 'features/splash/data/datasources/splash_remote_data_source.dart';
import 'features/splash/data/repositories/splash_repository_impl.dart';
import 'features/splash/domain/repositories/splash_repository.dart';
import 'features/splash/domain/usecases/fetch_server_url.dart';
import 'features/splash/domain/usecases/get_app_config.dart';
import 'features/splash/domain/usecases/initialize_app.dart';
import 'features/splash/domain/usecases/set_walkthrough_consumed.dart';
import 'features/splash/domain/usecases/is_walkthrough_consumed.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';

// Auth imports
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/check_mobile.dart';
import 'features/auth/domain/usecases/check_email.dart';
import 'features/auth/domain/usecases/send_verification_code.dart';
import 'features/auth/domain/usecases/login_with_google.dart';
import 'features/auth/domain/usecases/skip_login.dart';
import 'features/auth/presentation/bloc/signup/signup_bloc.dart';
import 'features/auth/presentation/bloc/email/email_bloc.dart';
import 'features/auth/presentation/bloc/login/login_bloc.dart';
import 'features/auth/presentation/bloc/password/password_bloc.dart';
import 'features/auth/presentation/bloc/verification/verification_bloc.dart';
import 'features/auth/domain/entities/user.dart';

// Cart imports
import 'features/cart/data/datasources/cart_local_data_source.dart';
import 'features/cart/data/datasources/cart_remote_data_source.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/repositories/cart_repository.dart';
import 'features/cart/domain/usecases/get_cart_summary.dart';
import 'features/cart/domain/usecases/add_item_to_cart.dart';
import 'features/cart/domain/usecases/update_item_quantity.dart';
import 'features/cart/domain/usecases/remove_item_from_cart.dart';
import 'features/cart/domain/usecases/clear_cart.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';

// Order imports
import 'features/order/data/datasources/order_local_data_source.dart';
import 'features/order/data/datasources/order_remote_data_source.dart';
import 'features/order/data/repositories/order_repository_impl.dart';
import 'features/order/domain/repositories/order_repository.dart';
import 'features/order/domain/usecases/get_all_addresses.dart';
import 'features/order/domain/usecases/submit_order.dart';
import 'features/order/domain/usecases/get_available_time_slots.dart';
import 'features/order/domain/usecases/get_credit_cards.dart';
import 'features/order/domain/usecases/apply_redeem_code.dart';
import 'features/order/domain/usecases/confirm_order.dart';
import 'features/order/presentation/bloc/order_bloc.dart';

// Orders imports
import 'features/orders/data/datasources/orders_local_data_source.dart';
import 'features/orders/data/datasources/orders_remote_data_source.dart';
import 'features/orders/data/repositories/orders_repository_impl.dart';
import 'features/orders/domain/repositories/orders_repository.dart';
import 'features/orders/domain/usecases/get_all_orders.dart';
import 'features/orders/domain/usecases/get_history_orders.dart';
import 'features/orders/domain/usecases/get_order_details.dart';
import 'features/orders/domain/usecases/cancel_order.dart';
import 'features/orders/domain/usecases/get_cached_orders.dart';
import 'features/orders/presentation/bloc/orders_bloc.dart';
// Home imports
import 'features/home/data/services/home_api_service.dart';
import 'core/config/locale_notifier.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Location Autocomplete (Mock or Google Places)
  if (AppConfig.useGooglePlaces) {
    getIt.registerLazySingleton<LocationAutocompleteService>(
      () => GooglePlacesAutocompleteService(client: getIt()),
    );
  } else {
    getIt.registerLazySingleton<LocationAutocompleteService>(
      () => MockLocationAutocompleteService(),
    );
  }
  //! Features - Order
  // Bloc
  getIt.registerFactory(
    () => OrderBloc(
      getAllAddresses: getIt(),
      submitOrder: getIt(),
      getAvailableTimeSlots: getIt(),
      getCreditCards: getIt(),
      applyRedeemCode: getIt(),
      confirmOrder: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetAllAddresses(getIt()));
  getIt.registerLazySingleton(() => SubmitOrder(getIt()));
  getIt.registerLazySingleton(() => GetAvailableTimeSlots(getIt()));
  getIt.registerLazySingleton(() => GetCreditCards(getIt()));
  getIt.registerLazySingleton(() => ApplyRedeemCode(getIt()));
  getIt.registerLazySingleton(() => ConfirmOrder(getIt()));

  // Repository
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
      splashLocalDataSource: getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton<OrderLocalDataSource>(
    () => OrderLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  getIt.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(client: getIt()),
  );

  //! Features - Orders
  // Bloc
  getIt.registerFactory(
    () => OrdersBloc(
      getAllOrders: getIt(),
      getHistoryOrders: getIt(),
      getOrderDetails: getIt(),
      cancelOrder: getIt(),
      getCachedOrders: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetAllOrders(getIt()));
  getIt.registerLazySingleton(() => GetHistoryOrders(getIt()));
  getIt.registerLazySingleton(() => GetOrderDetails(getIt()));
  getIt.registerLazySingleton(() => CancelOrder(getIt()));
  getIt.registerLazySingleton(() => GetCachedOrders(getIt()));

  // Repository
  getIt.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton<OrdersLocalDataSource>(
    () => OrdersLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  getIt.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(client: getIt()),
  );

  //! Features - Cart
  // Bloc
  getIt.registerFactory(
    () => CartBloc(
      getCartSummary: getIt(),
      addItemToCart: getIt(),
      updateItemQuantity: getIt(),
      removeItemFromCart: getIt(),
      clearCart: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetCartSummary(getIt()));
  getIt.registerLazySingleton(() => AddItemToCart(getIt()));
  getIt.registerLazySingleton(() => UpdateItemQuantity(getIt()));
  getIt.registerLazySingleton(() => RemoveItemFromCart(getIt()));
  getIt.registerLazySingleton(() => ClearCart(getIt()));

  // Repository
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(client: getIt()),
  );

  //! Features - Auth
  // Bloc
  getIt.registerFactory(
    () => SignUpBloc(
      checkMobile: getIt(),
      loginWithGoogle: getIt(),
      sendVerificationCode: getIt(),
      skipLogin: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => CheckMobile(getIt()));
  getIt.registerLazySingleton(() => CheckEmail(getIt()));
  getIt.registerLazySingleton(() => SendVerificationCode(getIt()));
  getIt.registerLazySingleton(() => LoginWithGoogle(getIt()));
  getIt.registerLazySingleton(() => SkipLogin(getIt()));

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: getIt()),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  //! Features - Splash
  // Bloc
  getIt.registerFactory(
    () => SplashBloc(
      fetchServerUrl: getIt(),
      getAppConfig: getIt(),
      initializeApp: getIt(),
    ),
  );

  getIt.registerFactory(
    () => EmailBloc(
      checkEmail: getIt(),
      sendVerificationCode: getIt(),
    ),
  );

  getIt.registerFactory(
    () => LoginBloc(
      checkMobile: getIt(),
      loginWithGoogle: getIt(),
      sendVerificationCode: getIt(),
    ),
  );

  getIt.registerFactoryParam<PasswordBloc, User, bool>(
    (user, isNewUser) => PasswordBloc(
      sendVerificationCode: getIt(),
      authLocalDataSource: getIt(),
      authRepository: getIt(),
      user: user,
      isNewUser: isNewUser,
    ),
  );

  getIt.registerFactoryParam<VerificationBloc, Map<String, dynamic>, void>(
    (params, _) => VerificationBloc(
      sendVerificationCode: getIt(),
      repository: getIt(),
      identifier: params['identifier'] as String,
      isPhone: params['isPhone'] as bool,
      isFromForgetPassword: params['isFromForgetPassword'] as bool? ?? false,
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => FetchServerUrl(getIt()));
  getIt.registerLazySingleton(() => GetAppConfig(getIt()));
  getIt.registerLazySingleton(() => InitializeApp(getIt()));
  getIt.registerLazySingleton(() => SetWalkThroughConsumed(getIt()));
  getIt.registerLazySingleton(() => IsWalkThroughConsumed(getIt()));

  // Repository
  getIt.registerLazySingleton<SplashRepository>(
    () => SplashRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton<SplashRemoteDataSource>(
    () => SplashRemoteDataSourceImpl(client: getIt()),
  );

  getIt.registerLazySingleton<SplashLocalDataSource>(
    () => SplashLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  // Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => http.Client());
  // getIt.registerLazySingleton(() => Connectivity()); // Temporarily disabled

  // Services
  getIt.registerLazySingleton(() => HomeApiService(client: getIt(), sharedPreferences: getIt()));

  // Locale Notifier
  final localeNotifier = await LocaleNotifier.create(sharedPreferences);
  getIt.registerLazySingleton<LocaleNotifier>(() => localeNotifier);
}
