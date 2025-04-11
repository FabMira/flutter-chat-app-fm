import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:chat/helper/mostrar_alerta.dart';
import 'package:chat/presentation/widgets/widgets.dart';
import 'package:chat/services/auth_service.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                Logo(title: 'Registro'),
                _Form(),
                Label(
                  ruta: 'login',
                  labelCuenta: '¿Ya tienes una cuenta?',
                  labelRuta: 'Ingresa ahora!',
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
  final nameCtrl = TextEditingController();
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
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            textController: nameCtrl,
            keyboardType: TextInputType.text,
          ),
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
                      final registerOk = await authService.register(
                        nameCtrl.text,
                        emailCtrl.text,
                        passCtrl.text,
                      );
                      if (registerOk['ok']) {
                        if (context.mounted) {
                          context.pushReplacementNamed('usuarios');
                        }
                      } else {
                        if (context.mounted) {
                          mostrarAlerta(
                            context,
                            'Registro incorrecto',
                            registerOk['msg'].toString(),
                          );
                        }
                      }
                    },
          ),
        ],
      ),
    );
  }
}
