import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/notifications/data/datasources/notification_remote_data_source.dart';
import 'features/notifications/data/repositories/notification_repository_impl.dart';
import 'features/notifications/domain/usecases/update_device_token.dart';
import 'features/notifications/presentation/manager/notification_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // IMPORTANT: Make sure you have added google-services.json (Android) and GoogleService-Info.plist (iOS)
  await Firebase.initializeApp();

  // Initialize Notification Manager (Permissions, Listeners)
  await NotificationManager.initialize();

  // External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  final client = http.Client();
  final firebaseMessaging = FirebaseMessaging.instance;

  // Data Sources
  final authRemoteDataSource = AuthRemoteDataSourceImpl(
    client: client,
    sharedPreferences: sharedPreferences,
  );
  final notificationRemoteDataSource = NotificationRemoteDataSourceImpl(
    firebaseMessaging: firebaseMessaging,
    client: client,
    sharedPreferences: sharedPreferences,
  );

  // Repositories
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
  );
  final notificationRepository = NotificationRepositoryImpl(
    remoteDataSource: notificationRemoteDataSource,
  );

  // Use Cases
  final loginUseCase = Login(authRepository);
  final updateDeviceTokenUseCase = UpdateDeviceToken(notificationRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: loginUseCase,
            updateDeviceTokenUseCase: updateDeviceTokenUseCase,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Clean Arch Login & FCM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
