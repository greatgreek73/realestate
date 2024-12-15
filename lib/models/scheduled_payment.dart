import 'package:hive/hive.dart';

part 'scheduled_payment.g.dart';

@HiveType(typeId: 2)
class ScheduledPayment extends HiveObject {
  @HiveField(0)
  final DateTime dueDate;

  @HiveField(1)
  final double plannedAmount;

  @HiveField(2)
  final String propertyId;

  @HiveField(3)
  double paidAmount;

  @HiveField(4)
  bool isCompleted;

  ScheduledPayment({
    required this.dueDate,
    required this.plannedAmount,
    required this.propertyId,
    this.paidAmount = 0,
    this.isCompleted = false,
  });
}