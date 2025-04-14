import 'dart:io';

class Environment {
  static String apiUrl =
      Platform.isAndroid
          ? 'http://192.168.137.65:3000' //'http://192.168.1.15:3000'
          : 'http://localhost:3000';
  static String socketUrl =
      Platform.isAndroid 
        ? 'http://192.168.137.65:3000' //'http://192.168.1.15:3000' 
        : 'http://localhost:3000';
}
