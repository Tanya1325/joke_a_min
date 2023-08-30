import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

Future<List<String>> fetchJoke() async {
  var client = http.Client();

  try {
    debugPrint("Fetching Joke!");
    final url =
        Uri.https('geek-jokes.sameerkumar.website', 'api', {'format': 'json'});
    var response = await client.get(url);
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    String joke = decodedResponse['joke'] as String;
    debugPrint("Fetched Result: $joke");
    return addJokeToQueue(joke);
  } finally {
    client.close();
  }
}

Future<List<String>> addJokeToQueue(String joke) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  debugPrint("Storing Joke!");
  final List<String> jokes = prefs.getStringList(jokesString) ?? [];

  if (jokes.length >= 10) {
    jokes.removeLast(); // Removing Last joke from the list
  }
  jokes.insert(0, joke); // Adding joke to the top of the list

  await prefs.setStringList(jokesString, jokes);
  return jokes;
}

Future<List<String>> getSavedJokes() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  debugPrint("Retrieving Joke!");
  final List<String> jokes = prefs.getStringList(jokesString) ?? [];

  return jokes;
}
