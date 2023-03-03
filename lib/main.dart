import 'package:flutter/material.dart';
import 'package:cashbook/pages/home.dart';
import 'package:cashbook/pages/cash_form.dart';
import 'package:cashbook/pages/cash_out.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  await Hive.initFlutter();
  var box = await Hive.openBox('cashbox');
  Hive.init(box.path);
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/' : (context) => Home(),
      '/form' : (context) => CashForm(),
      '/cashout' : (context) => CashOut(),
    },
  ));
}