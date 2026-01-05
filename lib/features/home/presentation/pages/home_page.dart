import 'package:flutter/material.dart';
import 'package:flutter_sqflite_2526_s9/core/database/database_helper.dart';
import 'package:flutter_sqflite_2526_s9/features/notifications/data/models/notification_model.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Use a Future builder or convert this to a Consumer if we used a Provider for Notifications
  // For simplicity, we'll use setState and load data manually.

  // Actually, standard setState approach is fine for this demo.
  // Better yet, let's use a simple FutureBuilder.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: DatabaseHelper().getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final notifications = snapshot.data as List<NotificationModel>;

          if (notifications.isEmpty) {
            return const Center(child: Text('No notifications yet.'));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Dismissible(
                key: Key(notification.id.toString()),
                background: Container(
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) async {
                  if (notification.id != null) {
                    await DatabaseHelper().deleteNotification(notification.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notification deleted')),
                    );
                  }
                },
                child: ListTile(
                  title: Text(notification.title),
                  subtitle: Text(notification.body),
                  trailing: Text(
                    notification.date.split('T').first +
                        '\n' +
                        notification.date.split('T').last.split('.').first,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
