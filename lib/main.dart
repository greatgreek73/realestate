import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/investment.dart';
import 'screens/investment_list_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register the adapter
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(InvestmentAdapter());
  }

  // Open the box
  await Hive.openBox<Investment>('investmentsBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real Estate Investment Tracker',
      theme: AppTheme.darkTheme,
      home: const InvestmentListScreen(),
    );
  }
}