import 'package:flutter/material.dart';
import '../models/payment.dart';
import '../theme/app_colors.dart';

class PaymentChart extends StatelessWidget {
  final List<Payment> payments;
  final double totalAmount;
  
  const PaymentChart({
    Key? key,
    required this.payments,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 200,
      child: const Placeholder(), // Здесь будет график
    );
  }
}