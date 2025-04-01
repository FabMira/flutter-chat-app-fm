import 'package:go_router/go_router.dart';
import 'package:chat/presentation/pages/pages.dart';

final appRouter = GoRouter(
  initialLocation: '/chat',
  routes: [
    GoRoute(
      path: '/', 
      builder: (context, state) => HomePage()
    ),
    GoRoute(
      path: '/loading', 
      builder: (context, state) => LoadingPage()
    ),
    GoRoute(
      path: '/login', 
      builder: (context, state) => LoginPage()
    ),
    GoRoute(
      path: '/chat', 
      builder: (context, state) => ChatPage()
    ),
    GoRoute(
      path: '/register', 
      builder: (context, state) => RegisterPage()
    ),
    GoRoute(
      path: '/usuarios', 
      builder: (context, state) => UsuariosPage()
    ),
  ],
);
