import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/scheduled_payment.dart';
import '../theme/app_colors.dart';

class CreatePaymentScheduleDialog extends StatefulWidget {
  final String propertyId;
  final double totalAmount;
  final Function(List<ScheduledPayment>) onScheduleCreated;

  const CreatePaymentScheduleDialog({
    Key? key,
    required this.propertyId,
    required this.totalAmount,
    required this.onScheduleCreated,
  }) : super(key: key);

  @override
  State<CreatePaymentScheduleDialog> createState() => _CreatePaymentScheduleDialogState();
}

class _CreatePaymentScheduleDialogState extends State<CreatePaymentScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _monthsController = TextEditingController();
  DateTime _startDate = DateTime.now();
  double _monthlyPayment = 0;
  int _months = 0;

  @override
  void dispose() {
    _monthsController.dispose();
    super.dispose();
  }

  void _calculateMonthlyPayment() {
    if (_months > 0) {
      setState(() {
        _monthlyPayment = widget.totalAmount / _months;
      });
    }
  }

  List<ScheduledPayment> _generateSchedule() {
    List<ScheduledPayment> schedule = [];
    DateTime currentDate = _startDate;

    for (int i = 0; i < _months; i++) {
      schedule.add(
        ScheduledPayment(
          dueDate: currentDate,
          plannedAmount: _monthlyPayment,
          propertyId: widget.propertyId,
        ),
      );
      currentDate = DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
    }

    return schedule;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.accent,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 0,
    );

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Payment Schedule',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Total Amount: ${currencyFormatter.format(widget.totalAmount)}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _monthsController,
                decoration: InputDecoration(
                  labelText: 'Number of Months',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.textPrimary),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      _months = int.parse(value);
                      _calculateMonthlyPayment();
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of months';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.accent),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Start Date',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            DateFormat('MMM dd, yyyy').format(_startDate),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_monthlyPayment > 0)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.overlay,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Monthly Payment:',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormatter.format(_monthlyPayment),
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final schedule = _generateSchedule();
                        widget.onScheduleCreated(schedule);
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Create Schedule'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}