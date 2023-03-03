import 'package:flutter/material.dart';
import 'package:cashbook/pages/home.dart';
import 'package:cashbook/pages/cash_form.dart';
import 'package:cashbook/pages/cash_out.dart';
import 'package:cashbook/models/cash_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  Hive.registerAdapter(CashModelAdapter());
  await Hive.openBox<CashModel>('cashbook');

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/' : (context) => Home(),
      '/form' : (context) => CashForm(),
      '/cashout' : (context) => CashOut(),
    },
  ));
}