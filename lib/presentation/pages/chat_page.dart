import 'dart:io';

import 'package:chat/presentation/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _estaEscribiendo = false;
  final List<ChatMessage> _messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 14,
              backgroundColor: Colors.blue[100],
              child: const Text('Te', style: TextStyle(fontSize: 12)),
            ),
            SizedBox(height: 3),
            const Text(
              'Melissa Flores',
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
        uid: '123',
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
  }

  @override
  void dispose() {
    //TODO: off del socket

    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
