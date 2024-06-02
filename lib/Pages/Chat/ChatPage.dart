import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/ChatProvider.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider()..connect(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Provider.of<ChatProvider>(context, listen: false).disconnect();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Consumer<ChatProvider>(
          builder: (context, provider, child) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.messages.length,
                    itemBuilder: (context, index) {
                      final message = provider.messages[index];
                      return ListTile(
                        title: Text(message['username']!),
                        subtitle: Text(message['message']!),
                      );
                    },
                  ),
                ),
                if (!provider.isConnected)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Disconnected. Trying to reconnect...',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                _MessageInputField(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MessageInputField extends StatefulWidget {
  @override
  __MessageInputFieldState createState() => __MessageInputFieldState();
}

class __MessageInputFieldState extends State<_MessageInputField> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      Provider.of<ChatProvider>(context, listen: false).sendMessage(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Enter your message'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
