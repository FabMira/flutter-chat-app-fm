import 'package:chat/global/environment.dart';
import 'package:chat/presentation/models/models.dart';
import 'package:chat/services/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_service.g.dart';

@Riverpod(keepAlive: true)
class UsuarioPara extends _$UsuarioPara {
  @override
  Usuario build() => Usuario(uid: '', nombre: '', email: '', online: false);

  void setUsuario(Usuario usuarioPara) {
    state = usuarioPara;
  }
}

@Riverpod(keepAlive: true)
Future<List<Mensaje>> getChat(Ref ref, String usuarioId) async {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      validateStatus: (status) => status != null && status < 500,
      contentType: 'application/json',
      responseType: ResponseType.json,
    ),
  );

  final token = await ref.read(authProvider.notifier).getToken();

  final resp = await dio.get(
    '/api/mensajes/$usuarioId',
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );

  final mensajesResponse = MensajesResponse.fromJson(resp.data);

  return mensajesResponse.mensajes;
}
