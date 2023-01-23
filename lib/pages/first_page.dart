import 'package:flutter/material.dart';
import 'package:pdf_invoice_generator_flutter/main.dart';
import 'package:pdf_invoice_generator_flutter/pages/create_table.dart';
import 'package:pdf_invoice_generator_flutter/pages/home_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  FirstPageState createState() => FirstPageState();
}

class FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mongery'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: const Text('Create Invoice'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserManager()),
                );
              },
              child: const Text('Create Table'),
            ),
          ],
        ),
      ),
    );
  }
}
