/*
// import 'package:extensionresoft/extensionresoft.dart';

import '../aa.dart';
import 'constants.dart';

/// USER ID
String get userID => sharedPreferencesService.getString('userID') ?? Constants.empty;

set userID(String value) => sharedPreferencesService.setString('userID', value);

/// AUTH TOKEN
String get authToken => sharedPreferencesService.getString('authToken') ?? Constants.empty;

set authToken(String value) => sharedPreferencesService.setString('authToken', value);

Future<bool> removeAuthToken() => sharedPreferencesService.remove('authToken');

/// CURRENT PAGE
*/ /*

*/
/*AppPage get page => getPage(sharedPreferencesService.getString('page') ?? AppPage.userVerification.name);

set page(AppPage value) => sharedPreferencesService.setString('page', value.name);*/ /*
*/
/*


/// SEEN ONBOARDING
bool get seenOnboarding => sharedPreferencesService.getBool('seenOnboarding') ?? false;

set seenOnboarding(bool value) => sharedPreferencesService.setBool('seenOnboarding', value);

/// PROMO CODE
String get promoCode => sharedPreferencesService.getString('promoCode') ?? Constants.empty;

set promoCode(String value) => sharedPreferencesService.setString('promoCode', value);*/ /*

*/

// import '../cc.dart';
import 'package:extensionresoft/extensionresoft.dart';

import 'constants.dart';

/// USER ID
String get userID => SharedPreferencesService.get('userID') ?? Constants.empty;

set userID(String value) => SharedPreferencesService.set('userID', value);

/// AUTH TOKEN
Future<String> get authToken async => await SharedPreferencesService.getAsync<String>('authToken') ?? Constants.empty;

set setAuthToken(String value) => SharedPreferencesService.set('authToken', value);

Future<void> removeAuthToken() => SharedPreferencesService.remove('authToken');

/// SEEN ONBOARDING
bool get seenOnboarding => SharedPreferencesService.get<bool>('seenOnboarding') ?? false;

set seenOnboarding(bool value) => SharedPreferencesService.set<bool>('seenOnboarding', value);

/// PROMO CODE
String get promoCode => SharedPreferencesService.get<String>('promoCode') ?? Constants.empty;

set promoCode(String value) => SharedPreferencesService.set<String>('promoCode', value);

/// INTERNET STATUS
bool get isInternet => SharedPreferencesService.getBool('isInternet') ?? false;

set isInternet(bool value) => SharedPreferencesService.setBool('isInternet', value);

/// SESSION ACTIVE
bool get sessionActive => SharedPreferencesService.get('sessionActive') ?? false;

set sessionActive(bool value) => SharedPreferencesService.set('sessionActive', value);

///

