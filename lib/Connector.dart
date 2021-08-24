import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'keys.dart';

// GET /api/v1/athlete/{id}/folders List all folders and workouts
// POST /api/v1/athlete/{id}/folders Create a folder
// PUT /api/v1/athlete/{id}/folders/{folderId} Update folder
// DELETE /api/v1/athlete/{id}/folders/{folderId} Delete folder
// GET /api/v1/athlete/{id}/folders/{folderId}/shared-with Show who folder has been shared with
// PUT /api/v1/athlete/{id}/folders/{folderId}/shared-with Update folder sharing
// GET /api/v1/athlete/{id}/workouts List all workouts (excluding those shared by others)
// GET /api/v1/athlete/{id}/workouts/{workoutId} Get a workout
// POST /api/v1/athlete/{id}/workouts Create a workout
// PUT /api/v1/athlete/{id}/workouts/{workoutId} Update a workout
// DELETE /api/v1/athlete/{id}/workouts/{workoutId} Delete a workout
// POST /api/v1/download-workout{ext} Download a workout in .zwo .mrc or .erg format

Future<void> getDailyEvent() async {

  DateTime currentTime = DateTime.now();
  String strTime = currentTime.toString().substring(0, 10);

  Map<String, String> qParams = {
    'oldest': '${strTime}',
    'newest': '${strTime}',
  };
  Uri uri = Uri.parse('https://intervals.icu/api/v1/athlete/${athleteID}/events');
  uri = uri.replace(queryParameters: qParams); //USE THIS

  debugPrint('Date: ${strTime}');
  final response = await http.get(
    uri,
    // Send authorization headers to the backend.
    headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: 'Basic ${auth_key}',
    },
  );

  debugPrint('Response code: ${response.statusCode}');
  if (response.statusCode != 200) {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print('Failed to create calendar entry.');
    //print(workoutToIcuJson(workout, date).toString());
  } else {
    debugPrint('Response: ${response.contentLength}');
    debugPrint('Body: ${response.body}');

    List<dynamic> listJsons = jsonDecode(response.body);

    for (var item in listJsons) {

      Album album = Album.fromJson(item);
      debugPrint('Body: ${album.toString()}');
    }
  }
}
//
// Future<void> postWeekCalendar(BuildContext context, PlannedWeek week) async {
//
//   Future<DateTime?> selectedDate = showDatePicker(
//     context: context,
//     initialDate: DateTime.now(),
//     firstDate: DateTime(2018),
//     lastDate: DateTime(2030),
//   );
//
//   DateTime? time = await selectedDate;
//
//   if (time == null) return;
//
//   for (var workout in week.workouts) {
//     String date = time!.toIso8601String();
//     print('Date upload: ${date}');
//     //print(workoutToIcuJson(workout, date).toString());
//     await postSingleCalendar(workout, date); //
//     time = time.add(Duration(days: 1));
//   }
// }

class Album {
  final int eventId;
  final String name;
  final String startDate;

  Album({
    required this.eventId,
    required this.name,
    required this.startDate,
  });

  String toString() {
    String ret = 'WKO name: ${name} date: ${startDate}';
    return ret;
  }

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      eventId: json['id'],
      name: json['name'],
      startDate: json['start_date_local'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': eventId,
      'name': name,
      'start_date_local': startDate,
    };
  }
}
