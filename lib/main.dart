import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/team_screen.dart';
import 'viewmodels/contact_viewmodel.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ContactViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TeamScreen(),
      ),
    );
  }
}
