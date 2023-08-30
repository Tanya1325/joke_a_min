import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as m;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../utilities/joke.dart';

class JokeProvider extends ChangeNotifier {
  List<String> jokes = [];
  bool isHorizontalView = false;
  Timer? timer;
  int milliSecond = 0;
  double timerIndicator = 0.0;
  final m.GlobalKey<m.AnimatedListState> listKey =
      m.GlobalKey<m.AnimatedListState>();

  JokeProvider() {
    getSavedJokes().then((value) {
      jokes = value;
      notifyListeners();
    });
  }

  rotateScrollOrientation() {
    isHorizontalView = !isHorizontalView;
    saveOrientationState();
  }

  fetchOrientationState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isHorizontalView = prefs.getBool(orientation) ?? false;
    notifyListeners();
  }

  saveOrientationState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(orientation, isHorizontalView);
    notifyListeners();
  }

  startTimer() {
    Timer? tickTick;

    timer = Timer.periodic(Duration(seconds: jokeFetchInSeconds), (Timer t) {
      milliSecond = 0;
      timerIndicator = milliSecond / ((jokeFetchInSeconds * 1000) - 1);
      fetchJoke();
      getSavedJokes().then((value) {
        jokes = value;
        notifyListeners();
      });

      // Remove
      // Add

      // To cancel previous seconds timer and start new timer for progress indicator value
      tickTick?.cancel();
      tickTick = Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
        milliSecond = milliSecond + 100;
        timerIndicator = milliSecond / ((jokeFetchInSeconds * 1000) - 1);
        notifyListeners();
      });
    });
  }
}
