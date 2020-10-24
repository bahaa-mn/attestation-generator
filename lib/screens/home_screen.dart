import 'package:acfgen/screens/editor_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/att_list.dart';
import '../widgets/editor.dart';

class Home extends StatefulWidget {
  static const routeName = "home-screen";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isEditing = false;

  final _list = <Map>[];

  @override
  void initState() {
    // get data from memory to set the list
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blueGrey,
        ),
        centerTitle: true,
        title: Text(
          'Attestation - Couvre Feu',
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newAttestation,
        child: Icon(Icons.add),
      ),
    );
  }

  void _newAttestation() async {
    final res = await Navigator.of(context).pushNamed(EditorScreen.routeName);
    // print('$res');
    if (res == null) return;
    setState(() {
      _list.add(res);
    });
  }

  void _modifyAttestation(Map old, Map m) {
    setState(() {
      final i = _list.indexOf(old);
      _list[i] = m;
    });
  }

  void _removeAttestation(Map m) async {
    Navigator.pop(context);
    final del = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer l\'attestation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Êtes vous sûr de vouloir supprimer cette attestation ?'),
                Text('Cette action est irréversible.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Supprimer'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            FlatButton(
              child: Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        );
      },
    );
    print('returned value dialog : $del');
    if (del)
      setState(() {
        _list.remove(m);
      });
  }
}
