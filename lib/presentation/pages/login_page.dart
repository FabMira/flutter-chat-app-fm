import 'package:chat/helper/mostrar_alerta.dart';
import 'package:chat/presentation/widgets/widgets.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(title: 'Messenger'),
                _Form(),
                Label(
                  ruta: 'register',
                  labelCuenta: '¿No tienes cuenta?',
                  labelRuta: 'Crea una Ahora!',
                ),
                const Text(
                  'Términos y condiciones de uso',
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            textController: emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            icon: Icons.lock_outlined,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),
          BotonAzul(
            text: 'ingrese',
            onPressed:
                authService.autenticando
                    ? () {}
                    : () async {
                      FocusScope.of(context).unfocus();
                      final loginOk = await authService.login(
                        emailCtrl.text.trim(),
                        passCtrl.text.trim(),
                      );
                      if (loginOk) {
                        // TODO: conectar a nuestro socket server
                        if(context.mounted) context.pushReplacementNamed('usuarios');
                      } else {
                        if (context.mounted) mostrarAlerta( context, 'Login incorrecto', 'Revise sus credenciales nuevamente' );
                      }
                    },
          ),
        ],
      ),
    );
  }
}
