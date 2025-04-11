import 'package:chat/config/router/app_router.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => AuthService() ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        routerConfig: appRouter,
      ),
    );
  }
}