import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_invoice_generator_flutter/model/urun_bilgileri.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:permission_handler/permission_handler.dart';

class UserManager extends StatefulWidget {
  const UserManager({Key? key}) : super(key: key);

  @override
  _UserManagerState createState() => _UserManagerState();
}

class _UserManagerState extends State<UserManager> {
  List<F> data = [];

  var tempRed = [];
  var tempCap = [];

  final capController = TextEditingController();
  final redController = TextEditingController();

  createCSV() {
    List<List<dynamic>> rows = <List<dynamic>>[];
    List<dynamic> row = <dynamic>[];
    row.add("Redüksiyon");
    row.add("Çap");
    rows.add(row);
    for (var i = 0; i < tempRed.length; i++) {
      List<dynamic> row = <dynamic>[];
      row.add(tempRed[i]);
      row.add(tempCap[i]);
      rows.add(row);
    }
    String csv = const ListToCsvConverter().convert(rows);
    print(csv);
    return csv;
  }

  Future<void> _createFile(String content) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final externalDir = await getExternalStorageDirectory();
      final myDir = Directory("${externalDir!.path}/csv");
      myDir.create();
      final file = File("${myDir.path}/test.csv");
      await file.writeAsString(content);
    } else {
      print("Permission deined");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hadde Hesaplama"),
      ),
      body: Column(
        children: [
          TextField(
            controller: capController,
            decoration: const InputDecoration(hintText: "Çap"),
          ),
          TextField(
            controller: redController,
            decoration: const InputDecoration(hintText: "Redüksiyon"),
          ),
          ElevatedButton(
              onPressed: () {
                // get Text and parse to double
                final capVal = capController.text.toString();
                final redVal = redController.text.toString();

                double cap = double.tryParse(capVal) ?? 0.0;
                double red = double.tryParse(redVal) ?? 0.0;

                cap = sqrt((1 - red) * pow(cap, 2));
                tempRed.add(red);
                tempCap.add(cap);

                for (var i = 0; i <= 12; i++) {
                  red = red - 0.01;
                  tempRed.add(red);
                  cap = sqrt((1 - red) * pow(cap, 2));
                  tempCap.add(cap);
                }

                setState(() {
                  data.add(F(cap: cap, red: red));
                });

                /// clear
                capController.clear();
                redController.clear();
              },
              child: const Text("ADD")),
          Expanded(
            child: GridView.builder(
              itemCount: tempCap.length,
              itemBuilder: (BuildContext ctxt, int i) {
                return Card(
                  child: Column(
                    children: [
                      Text("KAFA${i + 1}"),
                      Text("Çap: ${tempCap[i]}"),
                      Text("Redüksiyon: ${tempRed[i]}"),
                    ],
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                _createFile(createCSV());
              },
              child: const Text("CSV OLUŞTUR"))
        ],
      ),
    );
  }
}
