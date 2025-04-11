import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          return _LoadingScreen();
        },
        future: checkLoginState(context),
      ),
    );
  }
}

Future checkLoginState(BuildContext context) async {
  final authService = Provider.of<AuthService>(context, listen: false);
  final autenticado = await authService.isLoggedIn();

  if (autenticado) {
    // TODO: conectar al socket server
    if (context.mounted) {
      context.pushReplacementNamed('usuarios');
    } else {
          if (context.mounted) {
      context.pushReplacementNamed('login');
    }
    }
  }
}

class _LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Loading...', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
