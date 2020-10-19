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

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          'Attestation - Couvre Feu',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: AttestationList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(EditorScreen.routeName),
        child: Icon(Icons.add),
      ),
    );
  }
}
