// login_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'clipboard_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // Text controller for token input
  final tokenController = TextEditingController();

  // Function to handle login button tap
  void _login() async {

    // Get token from text field
    String token = tokenController.text;

    // Make API request
    var response = await http.get(
      Uri.parse('http://127.0.0.1:4096/clips/all?pass=$token'),
    );

    // If success, navigate to clipboard page
    if (response.statusCode == 200) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ClipboardPage(token: token),
        ),  
      );
    } else {
       showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('API returned status code: ${response.statusCode}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text('OK')
            )
          ],
        );
      }
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login'),
            SizedBox(height: 16),
            TextField(
              controller: tokenController,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login, 
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}