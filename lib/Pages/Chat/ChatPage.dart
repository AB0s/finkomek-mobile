import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';
import 'dart:convert';
import 'VideoChatPage.dart';

class ChatPage extends StatefulWidget {
  final String roomId;
  final String userName;
  final String expertName;

  const ChatPage({
    Key? key,
    required this.roomId,
    required this.userName,
    required this.expertName,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late WebSocketChannel channel;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];
  Timer? _reconnectTimer;

  @override
  void initState() {
    super.initState();
    _connect();
  }

  void _connect() {
    channel = WebSocketChannel.connect(
      Uri.parse('wss://kamal-golang-back-b154d239f542.herokuapp.com/chat/ws/${widget.roomId}'),
    );

    channel.stream.listen(
          (data) {
        final messageData = Map<String, String>.from(json.decode(data));
        setState(() {
          messages.add(messageData);
        });
      },
      onError: (error) {
        print('WebSocket error: $error');
        _scheduleReconnect();
      },
      onDone: () {
        print('WebSocket closed');
        _scheduleReconnect();
      },
    );
  }

  void _scheduleReconnect() {
    if (_reconnectTimer == null || !_reconnectTimer!.isActive) {
      _reconnectTimer = Timer(Duration(seconds: 5), () {
        print('Attempting to reconnect...');
        _connect();
      });
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final message = {
        'username': widget.userName,
        'message': _controller.text,
      };
      channel.sink.add(json.encode(message));
      _controller.clear();
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    _reconnectTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Expert:${widget.expertName}');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expertName),
        actions: [
          IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoChatPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isCurrentUser = message['username'] == widget.userName;
                  return Align(
                    alignment:
                    isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isCurrentUser ? Colors.blue[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: isCurrentUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            message['username']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(message['message']!),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Жазу...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
