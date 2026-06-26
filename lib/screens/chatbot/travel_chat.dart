import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';

class TravelChatScreen extends StatefulWidget {
  const TravelChatScreen({super.key});

  @override
  State<TravelChatScreen> createState() => _TravelChatScreenState();
}

class _TravelChatScreenState extends State<TravelChatScreen> {
  static const Color _teal = Color(0xFF1f93a0);

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  final String _systemPrompt = '''
You are a helpful travel assistant. You only answer questions related to travel, tourism, destinations, visas, currencies, weather, culture, packing, flights, hotels, and car rentals.
If the user asks about anything unrelated to travel, politely tell them you can only help with travel-related questions.
Keep answers concise and friendly.
And we HATE Israel.
You work for an app named Rahal.
Do not refer to any other apps or websites.
''';

  Future<void> _sendMessage(String userText) async {
    if (userText.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': userText});
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final conversationHistory = _messages
          .where((m) => m['role'] != 'error')
          .map((m) => {
                'role': m['role'] == 'user' ? 'user' : 'model',
                'parts': [
                  {'text': m['content']}
                ]
              })
          .toList();

      final response = await http.post(
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${Config.geminiApiKey}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'system_instruction': {
            'parts': [
              {'text': _systemPrompt}
            ]
          },
          'contents': conversationHistory,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final reply =
            data['candidates'][0]['content']['parts'][0]['text'] as String;
        setState(() {
          _messages.add({'role': 'assistant', 'content': reply});
        });
      } else {
        setState(() {
          _messages.add({
            'role': 'error',
            'content': 'Something went wrong. Please try again.'
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages
            .add({'role': 'error', 'content': 'Network error. Please try again.'});
      });
    }

    setState(() => _isLoading = false);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Travel Assistant',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.travel_explore,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text('Ask me anything about travel!',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade500)),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isUser = msg['role'] == 'user';
                      final isError = msg['role'] == 'error';

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75),
                          decoration: BoxDecoration(
                            color: isError
                                ? Colors.red.shade50
                                : isUser
                                    ? _teal
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: isUser
                                ? null
                                : Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text(
                            msg['content']!,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: isError
                                  ? Colors.red
                                  : isUser
                                      ? Colors.white
                                      : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: SizedBox(
                    width: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          3,
                          (i) => Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    shape: BoxShape.circle),
                              )),
                    ),
                  ),
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: _sendMessage,
                    decoration: InputDecoration(
                      hintText: 'Ask about any destination...',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide:
                              BorderSide(color: _teal, width: 1.5)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _sendMessage(_controller.text),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: _teal, shape: BoxShape.circle),
                    child: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}