import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter AI'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _aiResponse = '';
  String _blockchainResponse = '';
  String _userInput = '';

  Future<void> _callAIAPI() async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer *****',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'prompt': _userInput, // Use user input
        'max_tokens': 5,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _aiResponse = jsonDecode(response.body)['choices'][0]['text'];
      });
    } else {
      setState(() {
        _aiResponse = 'Failed to get response: ${response.statusCode} - ${response.body}';
      });
    }
  }

  Future<void> _callBlockchainAPI() async {
    final apiUrl = '****';
    final httpClient = http.Client();
    final ethClient = Web3Client(apiUrl, httpClient);

    try {
      final latestBlock = await ethClient.getBlockNumber();
      setState(() {
        _blockchainResponse = 'Latest Ethereum block: $latestBlock';
      });
    } catch (e) {
      setState(() {
        _blockchainResponse = 'Failed to get blockchain data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to Flutter AI'),
            TextField(
              onChanged: (value) {
                setState(() {
                  _userInput = value; // Update user input
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your prompt',
              ),
            ),
            ElevatedButton(
              onPressed: _callAIAPI,
              child: const Text('Call AI API'),
            ),
            Text(_aiResponse),
            ElevatedButton(
              onPressed: _callBlockchainAPI,
              child: const Text('Call Blockchain API'),
            ),
            Text(_blockchainResponse),
          ],
        ),
      ),
    );
  }
}