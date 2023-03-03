// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CashModelAdapter extends TypeAdapter<CashModel> {
  @override
  final int typeId = 0;

  @override
  CashModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CashModel(
      date: fields[0] as DateTime?,
      cashIn: fields[1] as double?,
      cashOut: fields[2] as double?,
      description: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CashModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.cashIn)
      ..writeByte(2)
      ..write(obj.cashOut)
      ..writeByte(3)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CashModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
