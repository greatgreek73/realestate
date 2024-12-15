import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/investment.dart';
import '../models/payment.dart';
import '../models/scheduled_payment.dart';
import '../theme/app_colors.dart';
import '../widgets/property_card.dart';
import '../widgets/add_payment_dialog.dart';
import '../widgets/create_payment_schedule_dialog.dart';

class PropertyDetailScreen extends StatelessWidget {
  final Investment investment;

  const PropertyDetailScreen({
    Key? key,
    required this.investment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var paymentsBox = Hive.box<Payment>('paymentsBox');
    var scheduledPaymentsBox = Hive.box<ScheduledPayment>('scheduledPaymentsBox');

    final currencyFormatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 0,
    ).format;

    String formatNumber(double value) {
      String formatted = currencyFormatter(value);
      return formatted.replaceAll(',', '.');
    }

    void addPayment(Payment payment) {
      paymentsBox.add(payment);
    }

    void addScheduledPayments(List<ScheduledPayment> payments) {
      for (var payment in payments) {
        scheduledPaymentsBox.add(payment);
      }
    }

    Widget buildContent() {
      final propertyPayments = paymentsBox.values
          .where((payment) => payment.propertyId == investment.propertyName)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      final scheduledPayments = scheduledPaymentsBox.values
          .where((payment) => payment.propertyId == investment.propertyName)
          .toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

      // Считаем сумму завершенных платежей из графика
      final completedScheduledPayments = scheduledPayments
          .where((payment) => payment.isCompleted)
          .toList();

      final totalPaid = completedScheduledPayments.fold<double>(
        0, (sum, payment) => sum + payment.plannedAmount
      );

      // Считаем процент выплаты
      final paymentPercentage = (totalPaid / investment.investmentAmount * 100)
          .clamp(0, 100)
          .toStringAsFixed(1);

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PropertyCard(
              investment: investment,
              isDetailScreen: true,
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Payment Progress',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$paymentPercentage%',
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: totalPaid / investment.investmentAmount,
                      backgroundColor: AppColors.overlay,
                      color: AppColors.accent,
                      minHeight: 10,
                    ),
                  ),
                ],
              ),
            ),

            if (scheduledPayments.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Payment Schedule',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: scheduledPayments.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final payment = scheduledPayments[index];
                  final isOverdue = payment.dueDate.isBefore(DateTime.now()) &&
                      !payment.isCompleted;
                  return Container(
                    padding: const EdgeInsets.all(16),
                    color: isOverdue 
                        ? Colors.red.withOpacity(0.1) 
                        : Colors.transparent,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('MMM dd, yyyy')
                                    .format(payment.dueDate),
                                style: TextStyle(
                                  color: isOverdue
                                      ? Colors.red
                                      : AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                payment.isCompleted
                                    ? 'Completed'
                                    : isOverdue
                                        ? 'Overdue'
                                        : 'Pending',
                                style: TextStyle(
                                  color: payment.isCompleted
                                      ? AppColors.accent
                                      : isOverdue
                                          ? Colors.red
                                          : AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formatNumber(payment.plannedAmount),
                              style: TextStyle(
                                color: isOverdue
                                    ? Colors.red
                                    : AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (payment.paidAmount > 0) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Paid: ${formatNumber(payment.paidAmount)}',
                                style: const TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ] else
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'No payment schedule yet',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => CreatePaymentScheduleDialog(
                              propertyId: investment.propertyName,
                              totalAmount: investment.investmentAmount,
                              onScheduleCreated: addScheduledPayments,
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Create Schedule'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Payment History',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            if (propertyPayments.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No payments yet',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: propertyPayments.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final payment = propertyPayments[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('MMM dd, yyyy')
                                    .format(payment.date),
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (payment.note != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  payment.note!,
                                  style: TextStyle(
                                    color: AppColors.textSecondary
                                        .withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Text(
                          formatNumber(payment.amount),
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 80),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          investment.propertyName,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CreatePaymentScheduleDialog(
                  propertyId: investment.propertyName,
                  totalAmount: investment.investmentAmount,
                  onScheduleCreated: addScheduledPayments,
                ),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<Payment>>(
        valueListenable: paymentsBox.listenable(),
        builder: (context, paymentsBoxValue, _) {
          return ValueListenableBuilder<Box<ScheduledPayment>>(
            valueListenable: scheduledPaymentsBox.listenable(),
            builder: (context, scheduledPaymentsBoxValue, _) {
              return buildContent();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddPaymentDialog(
              propertyId: investment.propertyName,
              onPaymentAdded: addPayment,
              scheduledPayments: scheduledPaymentsBox.values
                  .where((p) => p.propertyId == investment.propertyName)
                  .toList(),
            ),
          );
        },
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}