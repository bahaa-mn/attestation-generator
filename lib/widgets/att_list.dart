import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

import '../screens/print_screen.dart';
import '../utils/formtateurs.dart';
import '../screens/home_screen.dart';
import '../utils/constants.dart';
import './att_item.dart';
import './pdf_viewer.dart';

class AttestationList extends StatefulWidget {
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
  _AttestationListState createState() => _AttestationListState();
}

class _AttestationListState extends State<AttestationList> {
  var _isPreviewOpen = false;

  @override
  Widget build(BuildContext context) {
    final n = widget.list.length;

    return Container(
      child: n == 0
          ? Center(child: Text('Appuyez sur + pour créer une attestation.'))
          : Center(
              child: ListView.builder(
                itemCount: n,
                itemBuilder: (context, i) => GestureDetector(
                  child: AttestationItem(attestation: widget.list[n - 1 - i]),
                  onTap: _isPreviewOpen
                      ? null
                      : () => _onItemTap(context, widget.list[n - 1 - i]),
                ),
              ),
            ),
    );
  }

  void _onItemTap(BuildContext context, Map m) async {
    _isPreviewOpen = true;
    Navigator.of(context).popUntil(ModalRoute.withName(Home.routeName));
    widget.togglePreviewOpen(true, m);
    final sheet = showBottomSheet(
      context: context,
      builder: (context) => AttestPreview(
        m: m,
        modify: widget.modify,
        remove: widget.remove,
      ),
    );
    await sheet.closed;
    widget.togglePreviewOpen(false, m);
    _isPreviewOpen = false;
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
      // height: h,
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
                text: '${Formats.date(m[MapAttrs.date])} ',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: '${Formats.heure(m[MapAttrs.heure])}',
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
                text: '${m[MapAttrs.name].toString().toUpperCase()}  ',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: 'Mme/Mr',
                    style: TextStyle(
                      color: Colors.blueGrey[500],
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 33),
            RichText(
              text: TextSpan(
                text: '${m[MapAttrs.motif]['short'].toString().toUpperCase()} ',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: 'Motif',
                    style: TextStyle(
                      color: Colors.blueGrey[500],
                      fontSize: 13.0,
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
            FlatButton(
              color: Colors.blueGrey[100],
              child: Text('Apperçu'),
              onPressed: () => _printPDF(context),
            ),
            /* Row(
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
            ), */
            SizedBox(height: 13.0),
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

  /* _openPDF(BuildContext context) async {
    final fileName = Formats.fileName(m);
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/$fileName.pdf';
    // print("zlkgjzlekjglksd   \t $path");
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfViewerPage(path: path),
      ),
    );
  } */

  _printPDF(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PrintPDF(data: m),
      ),
    );
  }
}
