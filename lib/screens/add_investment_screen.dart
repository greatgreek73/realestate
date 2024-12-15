import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/investment.dart';
import '../theme/app_colors.dart';

class AddInvestmentScreen extends StatefulWidget {
  const AddInvestmentScreen({Key? key}) : super(key: key);

  @override
  State<AddInvestmentScreen> createState() => _AddInvestmentScreenState();
}

class _AddInvestmentScreenState extends State<AddInvestmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String _propertyName = '';
  double _investmentAmount = 0.0;
  double _amountPaid = 0.0;
  String _country = '';
  String _location = '';
  double _area = 0.0;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  Future<void> _pickDate(
    BuildContext context,
    DateTime initialDate,
    Function(DateTime) onDateSelected,
  ) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Investment'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  label: 'Property Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a property name';
                    }
                    return null;
                  },
                  onSaved: (value) => _propertyName = value!,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Investment Amount',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the investment amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) => _investmentAmount = double.parse(value!),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Amount Paid',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the amount paid';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) => _amountPaid = double.parse(value!),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Country',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a country';
                    }
                    return null;
                  },
                  onSaved: (value) => _country = value!,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Location',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                  onSaved: (value) => _location = value!,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Area (sq. m)',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the area';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) => _area = double.parse(value!),
                ),
                const SizedBox(height: 24),
                _buildDateSelector(
                  label: 'Start Date',
                  date: _startDate,
                  onTap: () => _pickDate(
                    context,
                    _startDate,
                    (date) => setState(() => _startDate = date),
                  ),
                ),
                const SizedBox(height: 16),
                _buildDateSelector(
                  label: 'End Date',
                  date: _endDate,
                  onTap: () => _pickDate(
                    context,
                    _endDate,
                    (date) => setState(() => _endDate = date),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _saveInvestment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Investment',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary,
          ),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.05),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveInvestment() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      var investmentsBox = Hive.box<Investment>('investmentsBox');
      investmentsBox.add(Investment(
        propertyName: _propertyName,
        investmentAmount: _investmentAmount,
        amountPaid: _amountPaid,
        country: _country,
        location: _location,
        area: _area,
        startDate: _startDate,
        endDate: _endDate,
      ));

      Navigator.pop(context);
    }
  }
}