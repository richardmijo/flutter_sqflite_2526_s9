import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/error/exceptions.dart';

abstract class NotificationRemoteDataSource {
  Future<String?> getFCMToken();
  Future<void> sendTokenToApi(String userId, String token);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseMessaging firebaseMessaging;
  final http.Client client;
  final SharedPreferences sharedPreferences;

  NotificationRemoteDataSourceImpl({
    required this.firebaseMessaging,
    required this.client,
    required this.sharedPreferences,
  });

  @override
  Future<String?> getFCMToken() async {
    return await firebaseMessaging.getToken();
  }

  @override
  Future<void> sendTokenToApi(String userId, String token) async {
    final authToken = sharedPreferences.getString(AppConstants.cachedTokenKey);

    // Platform detection
    String platform = 'web';
    if (Platform.isAndroid) platform = 'android';
    if (Platform.isIOS) platform = 'ios';

    final response = await client.post(
      Uri.parse(AppConstants.updateTokenEndpoint),
      body: json.encode({'token': token, 'platform': platform}),
      headers: {
        'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ServerException();
    }
  }
}
