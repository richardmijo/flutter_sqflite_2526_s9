import 'package:flutter/material.dart';
import '../../domain/usecases/login.dart';
import '../../domain/entities/user.dart';
import '../../../notifications/domain/usecases/update_device_token.dart';

enum AuthStatus { initial, loading, authenticated, error }

class AuthProvider extends ChangeNotifier {
  final Login loginUseCase;
  final UpdateDeviceToken updateDeviceTokenUseCase;

  AuthProvider({
    required this.loginUseCase,
    required this.updateDeviceTokenUseCase,
  });

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;

  Future<void> login(String username, String password) async {
    _status = AuthStatus.loading;
    notifyListeners();

    final result = await loginUseCase(
      LoginParams(username: username, password: password),
    );

    result.fold(
      (failure) {
        _status = AuthStatus.error;
        _errorMessage =
            'Login failed. Please check your credentials or connection.';
        notifyListeners();
      },
      (user) async {
        _user = user;
        // Sync FCM Token
        final tokenResult = await updateDeviceTokenUseCase(user.id);
        tokenResult.fold(
          (failure) => print("Error syncing token: $failure"),
          (_) => print("Token synced successfully"),
        );

        _status = AuthStatus.authenticated;
        _errorMessage = null;
        notifyListeners();
      },
    );
  }

  void logout() {
    _status = AuthStatus.initial;
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }
}
