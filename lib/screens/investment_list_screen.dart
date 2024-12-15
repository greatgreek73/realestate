import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/investment.dart';
import '../widgets/property_card.dart';
import '../theme/app_colors.dart';
import 'add_investment_screen.dart';

class InvestmentListScreen extends StatelessWidget {
  const InvestmentListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var investmentsBox = Hive.box<Investment>('investmentsBox');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Real Estate Investments'),
      ),
      body: ValueListenableBuilder(
        valueListenable: investmentsBox.listenable(),
        builder: (context, Box<Investment> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text(
                'No investments yet',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
            );
          }
          
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final investment = box.getAt(index)!;
              return Dismissible(
                key: Key(investment.propertyName),
                background: Container(
                  color: Colors.red.withOpacity(0.2),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  box.deleteAt(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${investment.propertyName} deleted'),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                },
                child: PropertyCard(
                  investment: investment,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddInvestmentScreen()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}