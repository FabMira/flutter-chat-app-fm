import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chat/presentation/pages/pages.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/loading',
    routes: [
      GoRoute(path: '/', name: 'home', builder: (context, state) => HomePage()),
      GoRoute(
        path: '/loading',
        name: 'loading',
        builder: (context, state) => LoadingPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, state) => ChatPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => RegisterPage(),
      ),
      GoRoute(
        path: '/usuarios',
        name: 'usuarios',
        builder: (context, state) => UsuariosPage(),
      ),
    ],
  );
}
