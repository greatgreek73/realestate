import 'package:hive/hive.dart';

part 'investment.g.dart';

@HiveType(typeId: 0)
class Investment {
  @HiveField(0)
  final String propertyName;
  
  @HiveField(1)
  final double investmentAmount;
  
  @HiveField(2)
  final double amountPaid;
  
  @HiveField(3)
  final String country;
  
  @HiveField(4)
  final String location;
  
  @HiveField(5)
  final double area;
  
  @HiveField(6)
  final DateTime startDate;
  
  @HiveField(7)
  final DateTime endDate;

  Investment({
    required this.propertyName,
    required this.investmentAmount,
    required this.amountPaid,
    required this.country,
    required this.location,
    required this.area,
    required this.startDate,
    required this.endDate,
  });
}