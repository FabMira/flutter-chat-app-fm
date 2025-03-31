import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Label extends StatelessWidget {
  final String ruta;
  final String labelCuenta;
  final String labelRuta;
  const Label({super.key, required this.ruta, required this.labelCuenta, required this.labelRuta});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          labelCuenta,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => context.pushReplacement('/$ruta'),
          child: Text(
            labelRuta,
            style: TextStyle(
              color: Colors.blue[600],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
