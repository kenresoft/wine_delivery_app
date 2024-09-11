import 'package:extensionresoft/extensionresoft.dart';

import 'constants.dart';

/// USER ID
String get userID => SharedPreferencesService.getString('userID') ?? Constants.empty;

set userID(String value) => SharedPreferencesService.setString('userID', value);

/// AUTH TOKEN
String get authToken => SharedPreferencesService.getString('authToken') ?? Constants.empty;

set authToken(String value) => SharedPreferencesService.setString('authToken', value);

Future<bool> removeAuthToken() => SharedPreferencesService.remove('authToken');

/// CURRENT PAGE
/*AppPage get page => getPage(SharedPreferencesService.getString('page') ?? AppPage.userVerification.name);

set page(AppPage value) => SharedPreferencesService.setString('page', value.name);*/

/// SEEN ONBOARDING
bool get seenOnboarding => SharedPreferencesService.getBool('seenOnboarding') ?? false;

set seenOnboarding(bool value) => SharedPreferencesService.setBool('seenOnboarding', value);

/// PROMO CODE
String get promoCode => SharedPreferencesService.getString('promoCode') ?? Constants.empty;

set promoCode(String value) => SharedPreferencesService.setString('promoCode', value);