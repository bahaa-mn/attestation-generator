import 'package:acfgen/widgets/editor.dart';
import 'package:flutter/material.dart';

class EditorScreen extends StatefulWidget {
  static const routeName = 'editor-screen';

  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;

    print('qskfllqksjglkqjglqsglkqjsglkjg $args');
    final editor = EditorAttestation(m: args);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blueGrey,
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          'Création attestation',
          style: TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: editor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _validForm(context, editor),
        label: Text('Générer'),
      ),
    );
  }

  void _validForm(BuildContext ctx, EditorAttestation editor) {
    if (!editor.state.isFormValid()) return;

    final data = editor.state.getData();
    // print('sldkjglksjdglk 22222 $data');

    Navigator.of(ctx).pop(data);
  }
}
