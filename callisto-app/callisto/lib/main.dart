// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/login_page/login_page.dart';
import 'clipboard_page/clipboard_page.dart';
import 'clipboard_page/clipboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clipboard App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(),
          ),
          BlocProvider<ClipboardBloc>(
            create: (_) => ClipboardBloc(sharedPreferences: sharedPreferences),
          ),
        ],
        child: LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final _tokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
                  final token = _tokenController.text;
                  if (token.isNotEmpty) {
                    context.read<AuthBloc>().add(LoginEvent(token: token));
                  }
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

class ClipboardHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clipboard History'),
      ),
      body: Center(
        child: BlocBuilder<ClipboardBloc, ClipboardState>(
          builder: (context, state) {
            if (state is ClipboardEmpty) {
              return Text('No clipboard history available');
            } else if (state is ClipboardLoading) {
              return CircularProgressIndicator();
            } else if (state is ClipboardLoaded) {
              return Column(
                children: [
                  Text('Clipboard history fetched successfully'),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.clipboardItems.length,
                    itemBuilder: (context, index) {
                      final item = state.clipboardItems[index];
                      return ListTile(
                        title: Text(item.dateAndTime),
                        subtitle: Text(item.clipboardData),
                      );
                    },
                  ),
                ],
              );
            } else if (state is ClipboardError) {
              return Text('Failed to fetch clipboard history');
            } else {
              return Container();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ClipboardBloc>().add(FetchClipboardHistoryEvent());
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
