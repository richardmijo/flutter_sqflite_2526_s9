class AppConstants {
  // Use 10.0.2.2 for Android emulator to access localhost
  // Use your machine's IP address for physical devices, e.g., 'http://192.168.1.10:3000'
  static const String baseUrl = 'http://192.168.1.3:3000/api';

  static const String loginEndpoint = '$baseUrl/auth/login';
  static const String updateTokenEndpoint = '$baseUrl/notifications/token';
  static const String cachedTokenKey = 'CACHED_AUTH_TOKEN';
}
