import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class WheelDataProvider extends ChangeNotifier {
  final Map<String, int> chickenpiece = {'chestpiece': 0, 'legpiece': 0};
  bool showWheel = true;
  int _legpieceNos = 0;
  int _chestpieceNos = 0;
  int _iterator = 0;
  int? _lastSelectedIndex;
  bool _isSpinning = false;
  bool get isSpinning => _isSpinning;
  int? get lastSelectedIndex => _lastSelectedIndex;

  int get chestpieceNos => _chestpieceNos;
  int get legpieceNos => _legpieceNos;
  int get iterator => _iterator;
  final List<String> chicken = [];
  final List<String> names = [];
  final StreamController<int> controller = StreamController<int>();
  final Map<String, String> winList = {};
  void spinWheel() {
    if (chicken.isNotEmpty) {
      if (_isSpinning) return;

      _isSpinning = true;
      notifyListeners();
      final randomIndex = Random().nextInt(chicken.length);
      _lastSelectedIndex = randomIndex;
      controller.add(randomIndex);
    }
  }

  void setSpinning(bool value) {
    _isSpinning = value;
    notifyListeners();
  }

  void resetWheel() {
    showWheel = true;
    names.clear();
    _chestpieceNos = 0;
    _legpieceNos = 0;
    _iterator = 0;
    _lastSelectedIndex = null;
    chicken.clear();
    winList.clear();
    notifyListeners();
  }

  void hideWheel() {
    showWheel = false;
    notifyListeners();
  }

  void incrementi() {
    if (_iterator < names.length) {
      _iterator += 1;
    }
    notifyListeners();
  }

  void makeIterator() {
    _iterator = 0;
  }

  void addWinner(String name, String piece) {
    winList[name] = piece;
    notifyListeners();
  }

  void incrementChestpiece() {
    _chestpieceNos += 1;
    notifyListeners();
  }

  void decrementChestpiece() {
    _chestpieceNos -= 1;
    notifyListeners();
  }

  void setChestpiece(int nos) {
    _chestpieceNos = nos;
    notifyListeners();
  }

  void incrementLegpiece() {
    _legpieceNos += 1;
    notifyListeners();
  }

  void decrementLegpiece() {
    _legpieceNos -= 1;
    notifyListeners();
  }

  void setLegpiece(int nos) {
    _legpieceNos = nos;
    notifyListeners();
  }

  void addName(String name) {
    names.add(name);
    notifyListeners();
  }

  void removeName(String name) {
    names.remove(name);
    notifyListeners();
  }

  void generateChickenList() {
    chicken
      ..clear()
      ..addAll([
        ...List.filled(_chestpieceNos, 'Chest Piece'),
        ...List.filled(_legpieceNos, 'Leg Piece'),
      ]);
    chicken.shuffle(Random());
    notifyListeners();
  }

  void removeOne(int index) {
    if (index >= 0 && index < chicken.length) {
      chicken.removeAt(index);
      notifyListeners();
    }
  }

  void disposeController() {
    controller.close();
  }
}
