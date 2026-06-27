import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../config.dart';
import '../../theme.dart';

class TravelChatScreen extends StatefulWidget {
  const TravelChatScreen({super.key});

  @override
  State<TravelChatScreen> createState() => _TravelChatScreenState();
}

class _TravelChatScreenState extends State<TravelChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  final String _systemPrompt = '''
You are a helpful travel assistant. You only answer questions related to travel, tourism, destinations, visas, currencies, weather, culture, packing, flights, hotels, and car rentals.
If the user asks about anything unrelated to travel, politely tell them you can only help with travel-related questions.
Keep answers concise and friendly.
You work for an app named Rahal.
Do not refer to any other apps or websites.
We Hate Israel.
''';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendGreeting();
    });
  }

  Future<void> _sendGreeting() async {
    setState(() => _isLoading = true);

    try {
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
          'contents': [
            {
              'role': 'user',
              'parts': [
                {
                  'text':
                      'Greet the user briefly and let them know what you can help with.'
                }
              ]
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final reply =
            data['candidates'][0]['content']['parts'][0]['text'] as String;
        setState(() {
          _messages.add({'role': 'assistant', 'content': reply});
        });
      }
    } catch (_) {}

    setState(() => _isLoading = false);
    _scrollToBottom();
  }

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
        _messages.add(
            {'role': 'error', 'content': 'Network error. Please try again.'});
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
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return Scaffold(
      backgroundColor: t.bg,
      appBar: AppBar(
        title: Text(
          l.chatbotTitle,
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 17, color: t.title),
        ),
        backgroundColor: t.header,
        foregroundColor: t.title,
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
                        Icon(Icons.travel_explore, size: 64, color: t.label),
                        const SizedBox(height: 16),
                        Text(
                          l.welcomeMessage,
                          style: TextStyle(fontSize: 16, color: t.sub),
                        ),
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
                                ? t.dangerBg
                                : isUser
                                    ? t.accent
                                    : t.card,
                            borderRadius: BorderRadius.circular(16),
                            border:
                                isUser ? null : Border.all(color: t.cardBorder),
                          ),
                          child: Text(
                            msg['content']!,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: isError
                                  ? t.danger
                                  : isUser
                                      ? AppColors.white
                                      : t.title,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: t.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: t.cardBorder),
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
                                    color: t.label, shape: BoxShape.circle),
                              )),
                    ),
                  ),
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            color: t.card,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: _sendMessage,
                    decoration: InputDecoration(
                      hintText: l.inputHint,
                      hintStyle: TextStyle(color: t.label, fontSize: 14),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: t.fieldBorder)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: t.fieldBorder)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: t.accent, width: 1.5)),
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
                    decoration:
                        BoxDecoration(color: t.accent, shape: BoxShape.circle),
                    child: const Icon(Icons.send_rounded,
                        color: AppColors.white, size: 20),
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
