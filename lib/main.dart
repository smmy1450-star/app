import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zlbvjprsbjopdooasrty.supabase.co',
    // ignore: deprecated_member_use
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpsYnZqcHJzYmpvcGRvb2FzcnR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA4MjA2MDYsImV4cCI6MjA5NjM5NjYwNn0.CUD-CJNsk9bwQyaju8x0RRWrp31fDa2DDT3fqTv3NCU',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text("Supabase Connected!"))),
    );
  }
}
