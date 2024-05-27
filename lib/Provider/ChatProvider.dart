import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider with ChangeNotifier {
  WebSocketChannel? _channel;
  List<Map<String, String>> _messages = [];
  String? _username;
  bool _isConnected = false;

  List<Map<String, String>> get messages => _messages;
  bool get isConnected => _isConnected;

  Future<void> connect() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('fname') ?? 'Unknown';

    _channel = WebSocketChannel.connect(
      Uri.parse('wss://kamal-golang-back-b154d239f542.herokuapp.com/chat/ws'),
    );

    _channel!.stream.listen((message) {
      final decodedMessage = json.decode(message);
      _messages.add({
        'username': decodedMessage['username'],
        'message': decodedMessage['message'],
      });
      notifyListeners();
    }, onError: (error) {
      _isConnected = false;
      notifyListeners();
    }, onDone: () {
      _isConnected = false;
      notifyListeners();
    });

    _isConnected = true;
    notifyListeners();
  }

  void sendMessage(String message) {
    if (_channel != null) {
      final msg = json.encode({
        'username': _username,
        'message': message,
      });
      _channel!.sink.add(msg);
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _isConnected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}
