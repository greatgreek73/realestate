// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvestmentAdapter extends TypeAdapter<Investment> {
  @override
  final int typeId = 0;

  @override
  Investment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Investment(
      propertyName: fields[0] as String,
      investmentAmount: fields[1] as double,
      amountPaid: fields[2] as double,
      country: fields[3] as String,
      location: fields[4] as String,
      area: fields[5] as double,
      startDate: fields[6] as DateTime,
      endDate: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Investment obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.propertyName)
      ..writeByte(1)
      ..write(obj.investmentAmount)
      ..writeByte(2)
      ..write(obj.amountPaid)
      ..writeByte(3)
      ..write(obj.country)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.area)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.endDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvestmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
