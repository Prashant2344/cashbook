import 'package:flutter/material.dart';
import 'package:cashbook/pages/home.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/' : (context) => Home(),
    },
  ));
}