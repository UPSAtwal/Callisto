import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../clipboard_page/clipboard_page.dart';

class LoginPage extends StatelessWidget {
  final _tokenController = TextEditingController();

  void _loginUser(BuildContext context) async {
    final token = _tokenController.text;
    if (token.isNotEmpty) {
      const apiUrl =
          'http://34.131.252.50:4096/clips/all'; // Replace with your API endpoint

      try {
        final response = await http.post(Uri.parse(apiUrl), body: {
          'token': token,
        });

        if (response.statusCode == 200) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ClipboardHistoryPage(),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid token. Please try again.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Failed'),
            content: Text(
                'An error occurred while logging in. Please try again later.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login to Callisto'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _tokenController,
                decoration: InputDecoration(labelText: 'Token'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _loginUser(context);
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
