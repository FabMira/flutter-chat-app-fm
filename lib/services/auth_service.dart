import 'package:chat/presentation/models/models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:chat/global/environment.dart';

part 'auth_service.g.dart';

@riverpod
class Auth extends _$Auth {
  final _storage = const FlutterSecureStorage();
  bool _autenticando = false;

  final _dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      validateStatus: (status) => status != null && status < 500,
      contentType: 'application/json',
      responseType: ResponseType.json,
    ),
  );

  @override
  Future<Usuario?> build() async {
    // Initial state
    return _restoreSession();
  }

  Future<Usuario?> _restoreSession() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) return null;

      final resp = await _dio.get(
        '/api/login/renew',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
        final loginResponse = LoginResponse.fromJson(resp.data);
        if (loginResponse.usuario != null) {
          await _guardarToken(loginResponse.token);
          return loginResponse.usuario;
        }
      }
      
      await logout();
      return null;
    } catch (e) {
      await logout();
      return null;
    }
  }

  bool get autenticando => _autenticando;
  set autenticando(bool valor) {
    _autenticando = valor;
    ref.notifyListeners();
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    try {
      autenticando = true;
      final data = {'email': email, 'password': password};
      final resp = await _dio.post('/api/login', data: data);

      if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
        final loginResponse = LoginResponse.fromJson(resp.data);
        if (loginResponse.usuario != null) {
          state = AsyncData(loginResponse.usuario);
          await _guardarToken(loginResponse.token);
          return true;
        }
      }
      return false;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    } finally {
      autenticando = false;
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    autenticando = true;
    final data = {
      'nombre': name.trim(),
      'email': email.trim(),
      'password': password.trim(),
    };
    final url = '/api/login/new';

    try {
      final resp = await _dio.post(url, data: data);
      if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
        final registerResponse = RegisterResponse.fromJson(resp.data);
        state = AsyncData(registerResponse.usuario);
        await _guardarToken(registerResponse.token);
        return {'ok': registerResponse.ok, 'msg': resp.data['msg']};
      }
      if (resp.statusCode == 400 && resp.data is Map<String, dynamic>) {
        if (resp.data.containsKey('errors')) {
          final msgError = resp.data.toString().substring(
            resp.data.toString().indexOf('msg') + 5,
            resp.data.toString().indexOf('path') - 2,
          );
          return {'ok': resp.data['ok'], 'msg': msgError};
        } else {
          return {'ok': resp.data['ok'], 'msg': resp.data['msg']};
        }
      }
      if (resp.statusCode == 500) {
        return {'ok': false, 'msg': 'Error en el servidor'};
      }
      return {'ok': false, 'msg': 'other error'};
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        print('Error: ${e.response?.data}');
      }
      return {'ok': false, 'msg': 'Exception: ${e.message}'};
    } catch (e) {
      print('Exception: $e');
      print('Stack trace: ${StackTrace.current}');
      return {'ok': false, 'msg': 'Exception: ${e.toString()}'};
    } finally {
      autenticando = false;
    }
  }

Future<bool> isLoggedIn() async {
  try {
    final usuario = await _restoreSession();
  state = AsyncData(usuario);
    return usuario != null;
  } catch (e, stack) {
    print('Error en isLoggedIn: $e');
    print('Stack: $stack');
    state = AsyncError(e, stack);
    return false;
  }
}

  Future<void> _guardarToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    state = const AsyncData(null);
  }
}
