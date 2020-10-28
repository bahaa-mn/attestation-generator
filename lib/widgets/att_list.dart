import 'dart:io';

import 'package:acfgen/screens/home_screen.dart';
import 'package:acfgen/screens/print_screen.dart';
import 'package:acfgen/utils/formtateurs.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

import 'package:acfgen/screens/editor_screen.dart';
import 'package:acfgen/utils/constants.dart';
import 'package:acfgen/widgets/att_item.dart';
import 'package:acfgen/widgets/pdf_viewer.dart';

class AttestationList extends StatelessWidget {
  final List<Map> list;
  final Function(Map old, Map m) modify;
  final Function(Map m) remove;
  final Function(bool open, Map m) togglePreviewOpen;

  AttestationList({
    @required this.list,
    @required this.remove,
    @required this.modify,
    @required this.togglePreviewOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) => GestureDetector(
            child: AttestationItem(attestation: list[i]),
            onTap: () => _onItemTap(context, list[i]),
          ),
        ),
      ),
    );
  }

  void _onItemTap(BuildContext context, Map m) async {
    Navigator.of(context).popUntil(ModalRoute.withName(Home.routeName));
    togglePreviewOpen(true, m);
    await showBottomSheet(
      context: context,
      builder: (context) => AttestPreview(
        m: m,
        modify: modify,
        remove: remove,
      ),
    ).closed;
    togglePreviewOpen(false, m);
  }
}

class AttestPreview extends StatelessWidget {
  final Map m;
  final Function(Map old, Map m) modify;
  final Function(Map m) remove;

  const AttestPreview({
    Key key,
    @required this.m,
    @required this.modify,
    @required this.remove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
        color: Colors.blueGrey[50],
      ),
      width: w,
      padding: const EdgeInsets.only(
        left: 17.0,
        right: 17.0,
        top: 23.0,
        bottom: 7.0,
      ),
      margin: const EdgeInsets.all(7.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: '${m[MapAttrs.date]} ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: '${m[MapAttrs.heure]}',
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 33),
            RichText(
              text: TextSpan(
                text: 'Mme/Mr \t',
                style: TextStyle(
                  color: Colors.blueGrey[500],
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: '${m[MapAttrs.name]}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 33),
            RichText(
              text: TextSpan(
                text: 'Motif \t',
                style: TextStyle(
                  color: Colors.blueGrey[500],
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: '${m[MapAttrs.motif]['short']}',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${m[MapAttrs.motif]['long']}',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 13.0),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(maxHeight: 35),
                    child: FlatButton(
                      color: Colors.blueGrey[100],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Apperçu'),
                          Icon(Icons.insert_drive_file),
                        ],
                      ),
                      onPressed: () => _openPDF(context),
                    ),
                  ),
                ),
                SizedBox(width: 17.0),
                Flexible(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: FlatButton(
                      color: Colors.blueGrey[100],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Imprimer'),
                          Icon(Icons.print),
                        ],
                      ),
                      onPressed: () => _printPDF(context),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 17.0),
            FlatButton(
              onPressed: () => remove(m),
              child: Text(
                'Supprimer',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  _openPDF(BuildContext context) async {
    final fileName = Formats.fileName(m);
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/$fileName.pdf';
    // print("zlkgjzlekjglksd   \t $path");
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfViewerPage(path: path),
      ),
    );
  }

  _printPDF(BuildContext context) async {
    final fileName = Formats.fileName(m);
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/$fileName.pdf';
    // print("zlkgjzlekjglksd   \t $path");
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PrintPDF(data: m),
      ),
    );
  }
}
