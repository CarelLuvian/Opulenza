import 'package:flutter/material.dart';
import 'akun.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Tambahkan ini

class ChatCustomerService extends StatefulWidget {
  const ChatCustomerService({super.key});

  @override
  State<ChatCustomerService> createState() => _ChatCustomerServiceState();
}

class _ChatCustomerServiceState extends State<ChatCustomerService> {
  final List<Map<String, String>> messages = [
    {'sender': 'bot', 'text': 'Halo! Ada yang bisa saya bantu?'},
    {'sender': 'bot', 'text': 'Anda bisa bertanya atau tekan tombol untuk menghubungi CS.'},
  ];

  final TextEditingController messageController = TextEditingController();
  bool chattingWithCS = false;

  Future<String> getChatbotReply(String message) async {
    final apiKey = dotenv.env['OPENAI_API_KEY']; // Ambil dari .env
    const apiUrl = 'https://api.openai.com/v1/chat/completions';

    if (apiKey == null || apiKey.isEmpty) {
      return "API Key tidak ditemukan. Pastikan sudah diset di file .env";
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "You are a helpful customer service bot."},
            {"role": "user", "content": message},
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return "Maaf, terjadi kesalahan saat memproses pesan.";
      }
    } catch (e) {
      return "Terjadi kesalahan koneksi. Silakan coba lagi.";
    }
  }

  void sendMessage(String text) async {
    setState(() {
      messages.add({'sender': 'user', 'text': text});
      messageController.clear();
    });

    if (!chattingWithCS) {
      final botReply = await getChatbotReply(text);
      setState(() {
        messages.add({'sender': 'bot', 'text': botReply});
      });
    } else {
      setState(() {
        messages.add({
          'sender': 'cs',
          'text': 'Halo! Ini CS. Ada yang bisa kami bantu?'
        });
      });
    }
  }

  void switchToCS() {
    setState(() {
      chattingWithCS = true;
      messages.add({
        'sender': 'cs',
        'text': 'Anda sekarang sedang berbicara dengan Customer Service.'
      });
    });
  }

  Widget buildMessage(Map<String, String> message) {
    bool isUser = message['sender'] == 'user';
    bool isCS = message['sender'] == 'cs';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUser
              ? Colors.blue[200]
              : isCS
              ? Colors.green[200]
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message['text'] ?? '',
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AkunPage()),
            );
          },
        ),
        title: const Text('Customer Service'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return buildMessage(messages[index]);
              },
            ),
          ),
          if (!chattingWithCS)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: switchToCS,
                child: const Text('Hubungi Customer Service'),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (messageController.text.trim().isNotEmpty) {
                      sendMessage(messageController.text.trim());
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
