// clipboard_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClipboardPage extends StatefulWidget {

  final String token;

  ClipboardPage({required this.token});

  @override
  _ClipboardPageState createState() => _ClipboardPageState();
}

class _ClipboardPageState extends State<ClipboardPage> {

  // List of clips
  List clips = [];

  @override
  void initState() {
    super.initState();
    
    // Get clips from API
    _getClips();
  }

  // Get clips from API
  void _getClips() async {
    var response = await http.get(
      Uri.parse('http://127.0.0.1:4096/clips/all?pass=${widget.token}'),
    );

    setState(() {
      clips = jsonDecode(response.body); 
    });
  }

  // Copy clip text to clipboard
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  // Post new clip 
  void _addClip(String text) async {

    // Post clip text
    await http.post(
      Uri.parse('http://127.0.0.1:4096/clips/post?pass=${widget.token}'),
      body: {
        'text': text,
      }
    );

    // Post client IP
    await http.post(
      Uri.parse('http://127.0.0.1:4096/clients/add?pass=${widget.token}'),
      body: {
        'addr': 'client_ip', //Get local IP
      }
    );

    // Update clips list
    _getClips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clipboard')),
      body: ListView.builder(
        itemCount: clips.length,
        itemBuilder: (context, index) {
          final clip = clips[index];

          return Card(
            child: ListTile(
              title: Text(clip['text']),
              onTap: () => _copyToClipboard(clip['text']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Get clip text from clipboard
          Clipboard.getData(Clipboard.kTextPlain).then((data) {
            _addClip(data!.text!);  
          });
        },
        child: Icon(Icons.add),
      ),  
    );
  }
}