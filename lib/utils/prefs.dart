import 'package:extensionresoft/extensionresoft.dart';

import 'constants.dart';

/// USER ID
String get userID => SharedPreferencesService.getString('userID') ?? Constants.empty;

set userID(String value) => SharedPreferencesService.setString('userID', value);

/// AUTH TOKEN
String get authToken => SharedPreferencesService.getString('authToken') ?? Constants.empty;

set authToken(String value) => SharedPreferencesService.setString('authToken', value);

Future<bool> removeAuthToken(String value) => SharedPreferencesService.remove('authToken');

/// CURRENT PAGE
/*AppPage get page => getPage(SharedPreferencesService.getString('page') ?? AppPage.userVerification.name);

set page(AppPage value) => SharedPreferencesService.setString('page', value.name);*/

///CACHE STATUS MESSAGE
String get statusMessage => SharedPreferencesService.getString('statusMessage') ?? Constants.empty;

set statusMessage(String value) => SharedPreferencesService.setString('statusMessage', value);