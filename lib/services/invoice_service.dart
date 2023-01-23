import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:open_document/open_document.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:pdf_invoice_generator_flutter/model/product.dart';

class CustomRow {
  final String itemName;
  final String itemfiyat;
  final String amount;
  final String total;
  final String vat;

  CustomRow(this.itemName, this.itemfiyat, this.amount, this.total, this.vat);
}

class PdfInvoiceService {
  Future<Uint8List> createHelloWorld() async {
    final font = await rootBundle.load("assets/fonts/AbhayaLibre-Regular.ttf");
    final ttf = Font.ttf(font);
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              "Hello World",
              style: TextStyle(font: ttf),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> createInvoice(List<Product> soldProducts) async {
    final font = await rootBundle.load("assets/fonts/AbhayaLibre-Regular.ttf");
    final ttf = Font.ttf(font);
    pw.Expanded itemColumn(List<CustomRow> elements) {
      return pw.Expanded(
        child: pw.Column(
          children: [
            for (var element in elements)
              pw.Row(
                children: [
                  pw.Expanded(
                      child: pw.Text(element.itemName,
                          style: TextStyle(font: ttf),
                          textAlign: pw.TextAlign.left)),
                  pw.Expanded(
                      child: pw.Text(element.itemfiyat,
                          style: TextStyle(font: ttf),
                          textAlign: pw.TextAlign.right)),
                  pw.Expanded(
                      child: pw.Text(element.amount,
                          style: TextStyle(font: ttf),
                          textAlign: pw.TextAlign.right)),
                  pw.Expanded(
                      child: pw.Text(element.total,
                          style: TextStyle(font: ttf),
                          textAlign: pw.TextAlign.right)),
                  pw.Expanded(
                      child: pw.Text(element.vat,
                          style: TextStyle(font: ttf),
                          textAlign: pw.TextAlign.right)),
                ],
              )
          ],
        ),
      );
    }

    final pdf = pw.Document();

    final List<CustomRow> elements = [
      CustomRow("Item Name", "Item fiyat", "Amount", "Total", "Vat"),
      for (var product in soldProducts)
        CustomRow(
          product.name,
          product.fiyat.toStringAsFixed(2),
          product.amount.toStringAsFixed(2),
          (product.fiyat * product.amount).toStringAsFixed(2),
          (product.cap * product.fiyat).toStringAsFixed(2),
        ),
      CustomRow(
        "Sub Total",
        "",
        "",
        "",
        "${getSubTotal(soldProducts)} EUR",
      ),
      CustomRow(
        "Vat Total",
        "",
        "",
        "",
        "${getVatTotal(soldProducts)} EUR",
      ),
      CustomRow(
        "Vat Total",
        "",
        "",
        "",
        "${(double.parse(getSubTotal(soldProducts)) + double.parse(getVatTotal(soldProducts))).toStringAsFixed(2)} EUR",
      )
    ];
    final image =
        (await rootBundle.load("assets/images/flutter_explained_logo.jpg"))
            .buffer
            .asUint8List();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Image(pw.MemoryImage(image),
                  width: 150, height: 150, fit: pw.BoxFit.cover),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Text("Cüstomer Name", style: TextStyle(font: ttf)),
                      pw.Text("Customer Address", style: TextStyle(font: ttf)),
                      pw.Text("Customer City", style: TextStyle(font: ttf)),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text("Max Weber", style: TextStyle(font: ttf)),
                      pw.Text("Weird Street Name 1",
                          style: TextStyle(font: ttf)),
                      pw.Text("77662 Not my City", style: TextStyle(font: ttf)),
                      pw.Text("Vat-id: 123456", style: TextStyle(font: ttf)),
                      pw.Text("Invoice-Nr: 00001", style: TextStyle(font: ttf))
                    ],
                  )
                ],
              ),
              pw.SizedBox(height: 50),
              pw.Text(
                  "Dear Customer, thanks for buying at Flutter Explained, feel free to see the list of items below.",
                  style: TextStyle(font: ttf)),
              pw.SizedBox(height: 25),
              itemColumn(elements),
              pw.SizedBox(height: 25),
              pw.Text("Thanks for your trust, and till the next time.",
                  style: TextStyle(font: ttf)),
              pw.SizedBox(height: 25),
              pw.Text("Kind regards,", style: TextStyle(font: ttf)),
              pw.SizedBox(height: 25),
              pw.Text("Max Weber", style: TextStyle(font: ttf))
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenDocument.openDocument(filePath: filePath);
  }

  String getSubTotal(List<Product> products) {
    return products
        .fold(0.0,
            (double prev, element) => prev + (element.amount * element.fiyat))
        .toStringAsFixed(2);
  }

  String getVatTotal(List<Product> products) {
    return products
        .fold(
          0.0,
          (double prev, next) =>
              prev + ((next.fiyat / 100 * next.cap) * next.amount),
        )
        .toStringAsFixed(2);
  }
}
