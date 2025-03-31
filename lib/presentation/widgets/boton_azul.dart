import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String label;
  // final String email;
  // final String password;
  final VoidCallback onPressed;
  const BotonAzul({
    super.key,
    required this.label,
    // required this.email,
    // required this.password, 
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: Colors.blue,
        shape: StadiumBorder(),
      ),
      onPressed: onPressed,
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ),
    );
  }
}
