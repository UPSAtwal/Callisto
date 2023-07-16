// clipboard_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'clipboard.dart';

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
              return ListView.builder(
                itemCount: state.clipboardItems.length,
                itemBuilder: (context, index) {
                  final item = state.clipboardItems[index];
                  return ListTile(
                    title: Text(item.dateAndTime),
                    subtitle: Text(item.clipboardData),
                    onTap: () {
                      context.read<ClipboardBloc>().add(
                            CopyToClipboardEvent(
                              clipboardData: item.clipboardData,
                            ),
                          );
                    },
                  );
                },
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
          final authBloc = context.read<AuthBloc>();
          if (authBloc.state == AuthStatus.authenticated) {
            final token = authBloc.getToken(); // Replace with your token retrieval logic
            context.read<ClipboardBloc>().add(
                  FetchClipboardHistoryEvent(token: token),
                );
          }
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
