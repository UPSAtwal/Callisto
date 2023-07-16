// clipboard.dart

import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

// Define the API endpoint for fetching clipboard history
const apiUrl = '34.131.252.50:4096/clips/all';

// Define the key for storing clipboard history in shared preferences
const clipboardHistoryKey = 'clipboard_history';

// Define the clipboard item model
class ClipboardItem {
  final String dateAndTime;
  final String clipboardData;

  ClipboardItem({required this.dateAndTime, required this.clipboardData});
}

// Define the clipboard history bloc and events
abstract class ClipboardState {}

class ClipboardEmpty extends ClipboardState {}

class ClipboardLoading extends ClipboardState {}

class ClipboardLoaded extends ClipboardState {
  final List<ClipboardItem> clipboardItems;

  ClipboardLoaded({required this.clipboardItems});
}

class ClipboardError extends ClipboardState {}

abstract class ClipboardEvent {}

class FetchClipboardHistoryEvent extends ClipboardEvent {
  final String token;

  FetchClipboardHistoryEvent({required this.token});
}

class CopyToClipboardEvent extends ClipboardEvent {
  final String clipboardData;

  CopyToClipboardEvent({required this.clipboardData});
}

class ClipboardBloc extends Bloc<ClipboardEvent, ClipboardState> {
  final SharedPreferences sharedPreferences;

  ClipboardBloc({required this.sharedPreferences}) : super(ClipboardEmpty());

  @override
  Stream<ClipboardState> mapEventToState(ClipboardEvent event) async* {
    if (event is FetchClipboardHistoryEvent) {
      yield ClipboardLoading();
      try {
        final response = await http.get(Uri.parse(apiUrl), headers: {
          'Authorization': 'Bearer ${event.token}',
        });

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as List;
          final clipboardItems = data
              .map((item) => ClipboardItem(
                    dateAndTime: item['dateAndTime'],
                    clipboardData: item['clipboardData'],
                  ))
              .toList();

          yield ClipboardLoaded(clipboardItems: clipboardItems);
        } else {
          throw Exception('Failed to fetch clipboard history');
        }
      } catch (error) {
        yield ClipboardError();
      }
    } else if (event is CopyToClipboardEvent) {
      try {
        await Clipboard.setData(ClipboardData(text: event.clipboardData));
      } catch (error) {
        // Handle clipboard copy error
      }
    }
  }
}
