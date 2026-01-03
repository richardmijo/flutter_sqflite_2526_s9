import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Clean Arch')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.status == AuthStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (authProvider.status == AuthStatus.authenticated) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login Successful!')),
                );
                // GoRouter manages redirection based on auth state, but we can also explicity go
                // effectively, the redirect listener in AppRouter should handle this anyway,
                // but explicit navigation is also fine for clarity.
                // context.go('/home'); // Optional, since redirect handles it
              });
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (authProvider.status == AuthStatus.error) ...[
                  Text(
                    authProvider.errorMessage ?? 'Error',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                ],
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final username = _usernameController.text;
                    final password = _passwordController.text;
                    if (username.isNotEmpty && password.isNotEmpty) {
                      authProvider.login(username, password);
                    }
                  },
                  child: const Text('Login'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
