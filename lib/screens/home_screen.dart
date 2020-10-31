import 'dart:convert';

import 'package:acfgen/screens/print_screen.dart';
import 'package:acfgen/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as pth;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import '../widgets/att_list.dart';
import './editor_screen.dart';
import '../utils/pdf_creator.dart';

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
    super.initState();
  }

  Future<Database> _database() async {
    return openDatabase(
      pth.join(await getDatabasesPath(), 'attestations_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE ${DatabaseConst.name} (${DatabaseConst.id} INTEGER PRIMARY KEY, ${MapAttrs.name} TEXT, ${MapAttrs.addresse} TEXT,${MapAttrs.birthCity} TEXT,${MapAttrs.birthday} TEXT, ${MapAttrs.date} TEXT, ${MapAttrs.heure} TEXT, ${MapAttrs.city} TEXT, ${DatabaseConst.motifId} INTEGER, ${MapAttrs.lastModif} TEXT)",
        );
      },
      version: 1,
    );
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
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _readAttestations(),
        builder: (context, _) {
          if (_list.length == 0)
            return Center(
                //child: CircularProgressIndicator(),
                child: Text(
              'Appuyer sur + pour créer une attestation',
              style: TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ));
          return AttestationList(
            list: _list,
            remove: _removeAttestation,
            modify: _modifyAttestation,
            togglePreviewOpen: _toggleIsPreviewOpen,
            printPdf: _printPDF,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: _isPreviewOpen ? () => _modify(context) : _newAttestation,
        child: Icon(_isPreviewOpen ? Icons.mode_edit : Icons.add),
      ),
    );
  }

  _printPDF(BuildContext context, Map m) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PrintPDF(data: m),
      ),
    );
  }

  DateTime todTOdt(TimeOfDay t) {
    final now = new DateTime.now();
    return new DateTime(now.year, now.month, now.day, t.hour, t.minute);
  }

  TimeOfDay dtTOtod(DateTime d) {
    return TimeOfDay(hour: d.hour, minute: d.minute);
  }

  Map<String, dynamic> attestationToDBMap(Map m) {
    final i = _list.indexOf(m);
    return {
      DatabaseConst.id: '$i',
      MapAttrs.name: m[MapAttrs.name],
      MapAttrs.addresse: m[MapAttrs.addresse],
      MapAttrs.birthCity: m[MapAttrs.birthCity],
      MapAttrs.birthday: (m[MapAttrs.birthday] as DateTime).toIso8601String(),
      MapAttrs.date: (m[MapAttrs.date] as DateTime).toIso8601String(),
      MapAttrs.heure: todTOdt(m[MapAttrs.heure]).toIso8601String(),
      MapAttrs.city: m[MapAttrs.city],
      DatabaseConst.motifId: MotifValue.list.indexOf(m[MapAttrs.motif]),
      MapAttrs.lastModif: (m[MapAttrs.lastModif] as DateTime).toIso8601String(),
    };
  }

  Future _readAttestations() async {
    if (_list.length != 0) return;
    final Database db = await _database();
    final List<Map<String, dynamic>> maps = await db.query(DatabaseConst.name);
    maps.forEach((e) {
      Map m = {
        MapAttrs.name: e[MapAttrs.name],
        MapAttrs.addresse: e[MapAttrs.addresse],
        MapAttrs.birthCity: e[MapAttrs.birthCity],
        MapAttrs.birthday: DateTime.parse(e[MapAttrs.birthday]),
        MapAttrs.date: DateTime.parse(e[MapAttrs.date]),
        MapAttrs.heure: dtTOtod(DateTime.parse(e[MapAttrs.heure])),
        MapAttrs.city: e[MapAttrs.city],
        MapAttrs.motif: MotifValue.list[e[DatabaseConst.motifId]],
        MapAttrs.lastModif: DateTime.parse(e[MapAttrs.lastModif]),
      };
      _list.add(m);
    });
  }

  _saveAttestation(Map m) async {
    final Database db = await _database();

    await db.insert(
      DatabaseConst.name,
      attestationToDBMap(m),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void _newAttestation() async {
    final m = await Navigator.of(context).pushNamed(EditorScreen.routeName);
    // print('$res');
    if (m == null) return;
    // PdfGenerator.saveFile(context, res);
    _list.add(m);
    _saveAttestation(m);
    _printPDF(context, m);
  }

  void _modifyAttestation(Map old, Map m) async {
    final i = _list.indexOf(old);
    setState(() {
      _list[i] = m;
      PdfGenerator.saveFile(context, m);
    });
    final db = await _database();
    // Update the given attestation.
    await db.update(
      DatabaseConst.name,
      attestationToDBMap(m),
      // Ensure that the attestation has a matching id.
      where: "id = ?",
      whereArgs: [i],
    );
  }

  void _removeAttestation(Map m) async {
    final i = _list.indexOf(m);
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
    if (del == null) return;
    if (del) {
      Navigator.pop(context);
      setState(() {
        _list.remove(m);
      });
      final db = await _database();
      // Remove the Dog from the Database.
      await db.delete(
        DatabaseConst.name,
        // Use a `where` clause to delete a specific dog.
        where: "id = ?",
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [i],
      );
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
