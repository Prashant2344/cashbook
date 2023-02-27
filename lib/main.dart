import 'package:flutter/material.dart';
import 'package:cashbook/pages/home.dart';
import 'package:cashbook/pages/cash_form.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/' : (context) => Home(),
      '/form' : (context) => CashForm(),
    },
  ));
}