import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;

  AuthRemoteDataSourceImpl({
    required this.client,
    required this.sharedPreferences,
  });

  @override
  Future<UserModel> login(String username, String password) async {
    final response = await client.post(
      Uri.parse(AppConstants.loginEndpoint),
      body: json.encode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final user = UserModel.fromJson(json.decode(response.body));
      // Save token locally
      await sharedPreferences.setString(
        AppConstants.cachedTokenKey,
        user.token,
      );
      return user;
    } else {
      throw ServerException();
    }
  }
}
