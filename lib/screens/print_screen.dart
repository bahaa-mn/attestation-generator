import 'dart:io';
import 'dart:typed_data';

import 'package:acfgen/utils/pdf_creator.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintPDF extends StatefulWidget {
  final Map data;

  PrintPDF({this.data});

  @override
  _PrintPDFState createState() => _PrintPDFState();
}

class _PrintPDFState extends State<PrintPDF> {
  static const title = 'Imprimer';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(color: Colors.blueGrey),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: PdfPreview(
          canChangePageFormat: false,
          build: (format) => _generatePdf(format, title),
          onPrinted: (context) {},
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = await PdfGenerator.reportView(context, widget.data);
    return pdf.save();
  }
}
