import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flight_companion_app/utils/ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

File messageJsonFile = File('messages.json');

void updateMessagesJson(messages) async {
  messageJsonFile.writeAsString(jsonEncode(messages));
}

class HandleAiMessage {
  String message;
  HandleAiMessage(this.message);
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
      updateMessagesJson(_messages);
    });
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handleAi(String prompt) async {
    // start talking to ai
    var aiResponse = talkToAi(prompt);

    // set initial 'thinking' message
    final textMessage = types.TextMessage(
      author: const types.User(
        id: 'ai',
      ),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: '...',
    );
    setState(() {
      _messages.insert(0, textMessage);
      updateMessagesJson(_messages);
    });

// every second replace last message with updated dot indicator
    String dots = "";
    Timer thinkingTimer = Timer(
        const Duration(seconds: 1),
        () => {
              if (dots.split('.').length == 3) {dots = ""},
              dots = "${dots}.",
              _messages.insert(
                  0,
                  types.TextMessage(
                    author: const types.User(
                      id: 'ai',
                    ),
                    createdAt: textMessage.createdAt,
                    id: const Uuid().v4(),
                    text: dots,
                  ))
            });

    // wait for response to be ready and update message
    String aiResponseText = await aiResponse;
    setState(() {
      thinkingTimer.cancel();
      _messages.removeLast();
      final aiResponseMessage = types.TextMessage(
          author: const types.User(
            id: 'ai',
          ),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          // text: extractAiPromptResponse(aiResponseText),
          text: aiResponseText);
      _messages.insert(0, aiResponseMessage);
      updateMessagesJson(_messages);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);

    _handleAi(message.text);
  }

  void _loadMessages() async {
// create the messageJsonFile if it does not exist with empty array
    if (!messageJsonFile.existsSync()) {
      messageJsonFile.create(recursive: true);
      messageJsonFile.writeAsStringSync('[]');
    }

    final messages = (jsonDecode(messageJsonFile.readAsStringSync()) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding:
              const EdgeInsets.only(bottom: 0, left: 16.0, right: 16.0, top: 0),
          child: Chat(
            messages: _messages,
            onMessageTap: _handleMessageTap,
            onSendPressed: _handleSendPressed,
            showUserAvatars: true,
            showUserNames: true,
            user: _user,
          ),
        ),
      );
}
