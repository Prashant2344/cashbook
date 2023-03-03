import 'package:hive/hive.dart';
import 'package:cashbook/models/cash_model.dart';

class Cashes{
  static Box<CashModel> getData() => Hive.box<CashModel>('cashbook');
}