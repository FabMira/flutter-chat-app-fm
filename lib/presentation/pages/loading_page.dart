import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import 'package:chat/services/services.dart';


class LoadingPage extends ConsumerWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          return _LoadingScreen();
        },
        future: checkLoginState(context, ref),
      ),
    );
  }
}

Future checkLoginState(BuildContext context, WidgetRef ref) async {
  final authService = ref.read(authProvider.notifier);
  final socketService = ref.read(socketServiceProvider.notifier);
  final autenticado = await authService.isLoggedIn();

  if (autenticado) {
    socketService.connect();
    if (context.mounted) {
      context.pushReplacementNamed('usuarios');
    } 
  }else {
    if (context.mounted) {
      context.pushReplacementNamed('login');
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
