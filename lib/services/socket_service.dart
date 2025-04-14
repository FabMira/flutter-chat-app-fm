import 'package:chat/services/services.dart';
import 'package:chat/global/environment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

part 'socket_service.g.dart';

enum ServerStatus { online, offline, connecting }

@Riverpod(keepAlive: true)
class SocketService extends _$SocketService {
  late IO.Socket _socket;
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  @override
  ServerStatus build() => ServerStatus.connecting;

  void connect() async {
  final token = await ref.read(authProvider.notifier).getToken();

  //  Dart client
  _socket = IO.io(Environment.socketUrl, {
    'transports': ['websocket'],
    'autoConnect': true,
    'forceNew': true,
    'extraHeaders': {'Authorization': 'Bearer $token'},
  });

  _socket.onConnect((_) {
    state = ServerStatus.online;
  });
  _socket.onDisconnect((_) {
    state = ServerStatus.offline;
  });
}

  void disconnect() {
    _socket.disconnect();
  }
}

// class SocketService with ChangeNotifier {
//   ServerStatus _serverStatus = ServerStatus.connecting;

//   ServerStatus get serverStatus => _serverStatus;


//   void connect() async {
//     final token = await AuthService.getToken();

//     //  Dart client
//     _socket = IO.io(Environment.socketUrl, {
//       'transports': ['websocket'],
//       'autoConnect': true,
//       'forceNew': true,
//       'extraHeaders': {'Authorization': 'Bearer $token'},
//     });

//     _socket.onConnect((_) {
//       _serverStatus = ServerStatus.online;
//       notifyListeners();
//     });
//     _socket.onDisconnect((_) {
//       _serverStatus = ServerStatus.offline;
//       notifyListeners();
//     });
//   }

//   void disconnect() {
//     _socket.disconnect();
//   }
// }
