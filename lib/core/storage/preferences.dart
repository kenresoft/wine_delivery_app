import 'package:vintiora/core/storage/local_storage.dart';
import 'package:vintiora/core/utils/constants.dart';

/// USER ID
String get userID => LocalStorage.get<String>('userID') ?? Constants.empty;

set userID(String value) => LocalStorage.set('userID', value);

/// AUTH TOKEN
String get authToken => LocalStorage.get<String>('authToken') ?? Constants.empty;

set authToken(String value) => LocalStorage.set('authToken', value);

Future<void> removeAuthToken() => LocalStorage.remove('authToken');

/// SEEN ONBOARDING
bool get seenOnboarding => LocalStorage.get<bool>('seenOnboarding') ?? false;

set seenOnboarding(bool value) => LocalStorage.set('seenOnboarding', value);

/// PROMO CODE
String get promoCode => LocalStorage.get<String>('promoCode') ?? Constants.empty;

set promoCode(String value) => LocalStorage.set<String>('promoCode', value);

/// SESSION ACTIVE
bool get sessionActive => LocalStorage.get('sessionActive') ?? false;

set sessionActive(bool value) => LocalStorage.set('sessionActive', value);

/// OTP SENT
bool get otpSent => LocalStorage.get('otpSent') ?? false;

set otpSent(bool value) => LocalStorage.set('otpSent', value);

/// EVENTS LOADED BEFORE
bool get eventsLoadedBefore => LocalStorage.get<bool>('eventsLoadedBefore') ?? false;

set eventsLoadedBefore(bool value) => LocalStorage.set('eventsLoadedBefore', value);

/// INTERNET STATUS
bool get isInternet => LocalStorage.get<bool>('isInternet') ?? false;

set isInternet(bool value) => LocalStorage.set<bool>('isInternet', value);

/// ALL STORAGE DATA
get storage => LocalStorage.getAll();

///
