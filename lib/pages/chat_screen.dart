import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:heatlth1/pages/chat_message.dart';
import 'package:velocity_x/velocity_x.dart';

import 'threedots.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = "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";
const Header = {
  "content-Type": "application/json",
  "Authorization": 'Bearer $apiKey'
};

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  late OpenAI? chatGPT;
  bool _isImageSearch = false;

  bool _isTyping = false;

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: _controller.text,
      sender: "You",
      isImage: false,
    );

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    _controller.clear();

    final response =
        await http.post(Uri.https("api.openai.com", "/v1/completions"),
            headers: Header,
            body: jsonEncode({
              "model": "text-davinci-003",
              "prompt":
                  "Try to behave like a health related chatbot for following queries:\n \n ${message.text}",
              "temperature": 0,
              "max_tokens": 200,
              'top_p': 1,
              'frequency_penalty': 0.0,
              'presence_penalty': 0.0
            }));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Vx.log(data);
      insertNewData(data["choices"][0]["text"], isImage: false);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void insertNewData(String response, {bool isImage = false}) {
    ChatMessage botMessage = ChatMessage(
      text: response,
      sender: "Heal+The Mate",
      isImage: isImage,
    );

    setState(() {
      _isTyping = false;
      _messages.insert(0, botMessage);
    });
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (value) => _sendMessage(),
            decoration: const InputDecoration.collapsed(hintText: "Ask here"),
          ),
        ),
        ButtonBar(
          children: [
            IconButton(
              icon: const Icon(Icons.send,color: Color.fromARGB(255,30, 125, 146,)),
              onPressed: () {
                _isImageSearch = false;
                _sendMessage();
              },
            ),
            // TextButton(
            //     onPressed: () {
            //       _isImageSearch = true;
            //       _sendMessage();
            //     },
            //     child: const Text("Generate Image"))
          ],
        ),
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: SafeArea(
            child: Column(
              children: [
                Flexible(
                    child: ListView.builder(
                  reverse: true,
                  padding: Vx.m8,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _messages[index];
                  },
                )),
                if (_isTyping) const ThreeDots(),
                const Divider(
                  height: 1.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: context.cardColor,
                  ),
                  child: _buildTextComposer(),
                )
              ],
            ),
          ),
        ));
  }
}
