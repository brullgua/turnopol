import 'package:flutter/material.dart';

class RootProvider extends ChangeNotifier {
  // Aquí puedes agregar la lógica y los datos que deseas compartir en toda la aplicación.
  int _index = 0;
  int get index => _index;
  set index(int value) {
    _index = value;
    notifyListeners();
  }

}