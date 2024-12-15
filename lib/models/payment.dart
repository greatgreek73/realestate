import 'package:hive/hive.dart';

part 'payment.g.dart';

@HiveType(typeId: 1)
class Payment extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String propertyId;

  @HiveField(3)
  final String? note;

  Payment({
    required this.date,
    required this.amount,
    required this.propertyId,
    this.note,
  });
}