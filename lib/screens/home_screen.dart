import 'package:acfgen/utils/pdf_creator.dart';
import 'package:flutter/material.dart';

import '../widgets/att_list.dart';
import './editor_screen.dart';

class Home extends StatefulWidget {
  static const routeName = "home-screen";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _list = <Map>[];

  var _isPreviewOpen = false;
  Map _previewedAttest;
  //check if preview open to change the floating action button usage

  @override
  void initState() {
    // get data from memory to set the list
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blueGrey,
        ),
        centerTitle: true,
        title: Text(
          'Vos attestations',
          style: TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: AttestationList(
        list: _list,
        remove: _removeAttestation,
        modify: _modifyAttestation,
        togglePreviewOpen: _toggleIsPreviewOpen,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isPreviewOpen ? () => _modify(context) : _newAttestation,
        child: Icon(_isPreviewOpen ? Icons.mode_edit : Icons.add),
      ),
    );
  }

  void _newAttestation() async {
    final res = await Navigator.of(context).pushNamed(EditorScreen.routeName);
    // print('$res');
    if (res == null) return;
    PdfGenerator.reportView(context, res);
    setState(() {
      _list.add(res);
    });
  }

  void _modifyAttestation(Map old, Map m) {
    setState(() {
      final i = _list.indexOf(old);
      _list[i] = m;
      PdfGenerator.reportView(context, m);
    });
  }

  void _removeAttestation(Map m) async {
    // Navigator.pop(context);
    final del = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer l\'attestation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Êtes vous sûr de vouloir supprimer cette attestation ?',
                  style: TextStyle(fontSize: 17.0),
                ),
                Text(
                  'Cette action est irréversible.',
                  style: TextStyle(fontSize: 13.0),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Supprimer',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            FlatButton(
              color: Colors.blueAccent,
              child: Text(
                'Annuler',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        );
      },
    );
    // print('returned value dialog : $del');
    if (del) {
      Navigator.pop(context);
      setState(() {
        _list.remove(m);
      });
    }
  }

  void _toggleIsPreviewOpen(bool open, Map m) {
    print('toggle preview open $open  \n$m');
    _isPreviewOpen = open;
    if (open && m != null) _previewedAttest = m;
    setState(() {});
  }

  void _modify(BuildContext context) async {
    Navigator.pop(context);
    final newM = await Navigator.of(context).pushNamed(
      EditorScreen.routeName,
      arguments: _previewedAttest,
    );
    _toggleIsPreviewOpen(false, newM);
    if (newM == null) return;
    _modifyAttestation(_previewedAttest, newM);
  }
}
