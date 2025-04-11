
import 'package:chat/presentation/models/models.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat/global/environment.dart';

class AuthService with ChangeNotifier {
  // final usuario
  Usuario? usuario;
  bool _autenticando = false;

  final _storage = FlutterSecureStorage();
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      validateStatus: (status) => status != null && status < 500,
      contentType: 'application/json',
      responseType: ResponseType.json,
    ),
  );

  bool get autenticando => _autenticando;
  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  // getters del token de forma estatica
  static Future<String?> getToken() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;
    final data = {'email': email, 'password': password};
    final url = '/api/login';

    try {
      final resp = await dio.post(url, data: data);
      autenticando = false;
      if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
        final loginResponse = LoginResponse.fromJson(resp.data);
        usuario = loginResponse.usuario;
        await _guardarToken(loginResponse.token);
        return true;
      }
      return false;
    } on DioException {
      throw Exception();
    } catch (e) {
      throw Exception();
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
      final resp = await dio.post(url, data: data);
      if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
        final registerResponse = RegisterResponse.fromJson(resp.data);
        usuario = registerResponse.usuario; // Save the user
        await _guardarToken(registerResponse.token);
        return {'ok': registerResponse.ok, 'msg': resp.data['msg']};
      }
      if (resp.statusCode == 400 && resp.data is Map<String, dynamic>) {
        // Handle error response
        if (resp.data.containsKey('errors')) {
          // Handle specific error
          final msgError = resp.data.toString().substring(
            resp.data.toString().indexOf('msg') + 5,
            resp.data.toString().indexOf('path') - 2,
          );
          return {'ok': resp.data['ok'], 'msg': msgError};
        } else {
          // Handle other error
          return {'ok': resp.data['ok'], 'msg': resp.data['msg']};
        }
      }
      if (resp.statusCode == 500) {
        // Handle server error
        return {'ok': false, 'msg': 'Error en el servidor'};
      }
      return {'ok': false, 'msg': 'other error'};
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        // Handle specific error
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
    final token = await _storage.read(key: 'token');
    final url = '/api/login/renew';
    final resp = await dio.get(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
      final loginResponse = LoginResponse.fromJson(resp.data);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    }
    logout();
    return false;
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
