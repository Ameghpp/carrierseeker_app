import 'package:carrier_seeker_app/home_screen.dart';
import 'package:carrier_seeker_app/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://supabase.com/dashboard/project/eotxxxnstghrdmexufzv',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVvdHh4eG5zdGdocmRtZXh1Znp2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI4NTcxNDIsImV4cCI6MjA0ODQzMzE0Mn0.g0LY5Uv80SEP-pb1i-6fv5p3VPC04LxiPbXH1C0Y0EY',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
