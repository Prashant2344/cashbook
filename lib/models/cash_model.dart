import 'package:hive/hive.dart';
part 'cash_model.g.dart';

@HiveType(typeId: 0)
class CashModel extends HiveObject{

  @HiveField(0)
  DateTime? date;
  
  @HiveField(1)
  double? cashIn;
  
  @HiveField(2)
  double? cashOut;
  
  @HiveField(3)
  String? description;

  CashModel({
    required this.date,
    this.cashIn,
    this.cashOut,
    this.description
  });
}