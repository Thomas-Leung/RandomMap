import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:random_map/models/nearby_search_model.dart';
import 'package:random_map/pages/login_page.dart';
import 'package:random_map/pages/map_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: 'https://mmzthwhvgiwcultnqozw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1tenRod2h2Z2l3Y3VsdG5xb3p3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDI1MDI0MTcsImV4cCI6MjAxODA3ODQxN30.ZNBmxy-dUewUKmsidmCovBlE9jkKUesTMax7urw0VeI',
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => NearbySearchModel(),
      child: const MyApp(),
    ),
  );
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
