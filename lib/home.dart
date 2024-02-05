import 'dart:developer';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController chatRoom = TextEditingController();
  final TextEditingController message = TextEditingController();
  String chatroom = "general";
  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    // Uncomment to establish WebSocket connection
    runWebSocket();
  }

  runWebSocket() async {
    final wsUrl = Uri.parse('ws://localhost:8084/ws');
    channel = WebSocketChannel.connect(wsUrl);

    // Uncomment to listen for messages from the server
    // channel.stream.listen((message) {
    //   print('Received: $message');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chat Application using Websocket",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                "Currently in chat: $chatroom",
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text("Chatroom:    "),
                  Expanded(
                    child: TextFormField(
                      controller: chatRoom,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (chatRoom.text.toString() != "") {
                      chatroom = chatRoom.text.toString();
                    } else {
                      chatroom = "general";
                    }
                  });
                },
                child: Text("Change Chatroom"),
              ),
              SizedBox(height: 16.0),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black)),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text("Message:    "),
                  Expanded(
                    child: TextFormField(
                      controller: message,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Send message over WebSocket
                  channel.sink.add(message.text);
                },
                child: Text("Send Message"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Reconnect to WebSocket server
                  runWebSocket();
                },
                child: Text("Test Connection"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
