import 'package:chat/global/environment.dart';
import 'package:chat/presentation/models/models.dart';
import 'package:chat/services/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'usuarios_service.g.dart';

@Riverpod(keepAlive: false)
Future<List<Usuario>> usersList(Ref ref) async {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      contentType: 'application/json',
      responseType: ResponseType.json,
    ),
  );
  try {
    final token = await ref.read(authProvider.notifier).getToken();
    final res = await dio.get(
      '/api/users',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final usuariosResponse = UsuariosResponse.fromJson(res.data);
    return usuariosResponse.users;
  } catch (e) {
    return [];
  }
}

// class UsuariosService {
//   final dio = Dio(
//     BaseOptions(
//       baseUrl: Environment.apiUrl,
//       // validateStatus: (status) => status != null && status < 500,
//       contentType: 'application/json',
//       responseType: ResponseType.json,
//     ),
//   );

//   Future<List<Usuario>> getUsuarios() async {
//     try {
//       final token = await AuthService.getToken();
//       final res = await dio.get(
//         '/api/users',
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );
//       final usuariosResponse = UsuariosResponse.fromJson(res.data);
//       return usuariosResponse.users;
//     } catch (e) {
//       return [];
//     }
//   }
// }
