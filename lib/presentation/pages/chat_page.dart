import 'dart:io';

import 'package:chat/presentation/models/models.dart';
import 'package:chat/presentation/widgets/chat_message.dart';
import 'package:chat/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends ConsumerState<ChatPage>
    with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _estaEscribiendo = false;
  final List<ChatMessage> _messages = [];
  late IO.Socket _socket;

  @override
  void initState() {
    super.initState();
    _socket = ref.read(socketServiceProvider.notifier).socket;
    _socket.on('mensaje-personal', _escucharMensaje);
    _cargarHistorial(ref.read(usuarioParaProvider).uid);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cargarHistorial(ref.read(usuarioParaProvider).uid);
  }

  void _cargarHistorial(String usuarioId) async {
    List<Mensaje> chat = await ref.refresh(getChatProvider(usuarioId).future);

    final history = chat.map(
      (m) => ChatMessage(
        texto: m.mensaje,
        uid: m.de,
        animationController: AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 0),
        )..forward(),
      ),
    );

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    ChatMessage message = ChatMessage(
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = ref.watch(usuarioParaProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 14,
              backgroundColor: Colors.blue[100],
              child: Text(
                usuarioPara.nombre.substring(0, 2),
                style: TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(height: 3),
            Text(
              usuarioPara.nombre,
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, index) => _messages[index],
              reverse: true,
            ),
          ),
          Divider(height: 1),
          Container(color: Colors.white, child: _inputChat()),
        ],
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (value) {
                  setState(() {
                    if (value.trim().isNotEmpty) {
                      _estaEscribiendo = true;
                    } else {
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child:
                  Platform.isIOS
                      ? CupertinoButton(
                        onPressed:
                            _estaEscribiendo
                                ? () =>
                                    _handleSubmit(_textController.text.trim())
                                : null,
                        child: Text('Enviar'),
                      )
                      : Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        child: IconTheme(
                          data: IconThemeData(color: Colors.blue[400]),
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed:
                                _estaEscribiendo
                                    ? () => _handleSubmit(
                                      _textController.text.trim(),
                                    )
                                    : null,
                            icon: Icon(Icons.send),
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    if (text.isNotEmpty) {
      final newMessage = ChatMessage(
        texto: text,
        uid: ref.read(authProvider).value!.uid,
        animationController: AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 200),
        ),
      );
      _messages.insert(0, newMessage);
      newMessage.animationController.forward();
    }
    _textController.clear();
    _focusNode.requestFocus();

    setState(() {
      _estaEscribiendo = false;
    });
    ref.read(socketServiceProvider.notifier).emit('mensaje-personal', {
      'de': ref.read(authProvider).value!.uid,
      'para': ref.read(usuarioParaProvider).uid,
      'mensaje': text,
    });
  }

  @override
  void dispose() {
    _socket.off('mensaje-personal');

    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
