import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/investment.dart';
import 'screens/investment_list_screen.dart';
import 'theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Настройка полноэкранного режима и прозрачности системных панелей
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Скрытие системных панелей
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [],
  );

  await Hive.initFlutter();
  Hive.registerAdapter(InvestmentAdapter());
  await Hive.openBox<Investment>('investmentsBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real Estate Investment Tracker',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.accent,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accent,
          secondary: AppColors.accent,
          background: AppColors.background,
          surface: AppColors.surface,
          onBackground: AppColors.textPrimary,
          onSurface: AppColors.textPrimary,
          onPrimary: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceLight,
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
            borderSide: const BorderSide(
              color: AppColors.accent,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const InvestmentListScreen(),
    );
  }
}

@HiveType(typeId: 0)
class InvestmentAdapter extends TypeAdapter<Investment> {
  @override
  final int typeId = 0;

  @override
  Investment read(BinaryReader reader) {
    return Investment(
      propertyName: reader.readString(),
      investmentAmount: reader.readDouble(),
      amountPaid: reader.readDouble(),
      country: reader.readString(),
      location: reader.readString(),
      area: reader.readDouble(),
      startDate: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      endDate: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, Investment obj) {
    writer.writeString(obj.propertyName);
    writer.writeDouble(obj.investmentAmount);
    writer.writeDouble(obj.amountPaid);
    writer.writeString(obj.country);
    writer.writeString(obj.location);
    writer.writeDouble(obj.area);
    writer.writeInt(obj.startDate.millisecondsSinceEpoch);
    writer.writeInt(obj.endDate.millisecondsSinceEpoch);
  }
}