// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/presentation/models/models.dart';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    final bool ok;
    final Usuario? usuario;
    final String token;

    LoginResponse({
        required this.ok,
        required this.usuario,
        required this.token,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"],
        usuario: json["usuarioDB"] != null
          ? Usuario.fromJson(json["usuarioDB"])
          : null,
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarioDB": usuario?.toJson(),
        "token": token,
    };
}
