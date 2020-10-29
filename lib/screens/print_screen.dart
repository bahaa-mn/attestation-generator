import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../utils/formtateurs.dart';
import '../utils/pdf_creator.dart';

class PrintPDF extends StatefulWidget {
  final Map data;

  PrintPDF({this.data});

  @override
  _PrintPDFState createState() => _PrintPDFState();
}

class _PrintPDFState extends State<PrintPDF> {
  @override
  Widget build(BuildContext context) {
    final title = Formats.fileName(widget.data);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.blueGrey),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blueGrey),
        actionsIconTheme: IconThemeData(color: Colors.blueGrey),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () async {
              await Printing.layoutPdf(
                onLayout: (format) async => _generatePdf(format, title),
              );
            },
          ),
        ],
      ),
      body: PdfPreview(
        canChangePageFormat: false,
        useActions: false,
        build: (format) => _generatePdf(format, title),
        // onPrinted: (context) {},
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = await PdfGenerator.reportView(context, widget.data);
    return pdf.save();
  }
}
