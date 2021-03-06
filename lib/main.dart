import 'package:flutter/material.dart';
import 'package:number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      theme: ThemeData(primaryColor: Colors.blue.shade600, accentColor: Colors.blue.shade300),
      home: NumberTriviaPage(),
    );
  }
}
