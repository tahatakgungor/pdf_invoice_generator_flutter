import 'package:flutter/material.dart';
import 'package:pdf_invoice_generator_flutter/pages/first_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'AbhayaLibre-Regular.ttf',
        textTheme: const TextTheme(
          bodyText2: TextStyle(
              fontSize: 14,
              fontFamilyFallback: ['Test']), // Default style for Material Text
          subtitle1: TextStyle(fontSize: 14, fontFamilyFallback: [
            'Test'
          ]), // Define your own style of subtitle
        ),
        primarySwatch: Colors.blue,
      ),
      home: const FirstPage(),
    );
  }
}
