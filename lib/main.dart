import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/contact_viewmodel.dart';
import 'views/team_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContactViewModel()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TeamScreen(),
    );
  }
}
