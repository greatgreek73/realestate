// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_payment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduledPaymentAdapter extends TypeAdapter<ScheduledPayment> {
  @override
  final int typeId = 2;

  @override
  ScheduledPayment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduledPayment(
      dueDate: fields[0] as DateTime,
      plannedAmount: fields[1] as double,
      propertyId: fields[2] as String,
      paidAmount: fields[3] as double,
      isCompleted: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ScheduledPayment obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.dueDate)
      ..writeByte(1)
      ..write(obj.plannedAmount)
      ..writeByte(2)
      ..write(obj.propertyId)
      ..writeByte(3)
      ..write(obj.paidAmount)
      ..writeByte(4)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduledPaymentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
