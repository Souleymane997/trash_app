import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'platform.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://syjsibsbjickquqpvjae.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5anNpYnNiamlja3F1cXB2amFlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc1NzcyNTMsImV4cCI6MjA2MzE1MzI1M30.iEUPHZB67TxiNo8x7E85jc_Aug9p9VTcVuR3WQJDo60',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        locale: Locale('fr'),
        supportedLocales: [
          Locale('fr'),
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          SfGlobalLocalizations.delegate, // Syncfusion
        ],
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: PlatformPage(),
        debugShowCheckedModeBanner: false
    );
  }
}