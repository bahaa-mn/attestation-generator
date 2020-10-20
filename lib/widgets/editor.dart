import 'package:acfgen/utils/constants.dart';
import 'package:flutter/material.dart';

class EditorAttestation extends StatefulWidget {
  final state = _EditorAttestationState();

  @override
  _EditorAttestationState createState() => state;
}

class _EditorAttestationState extends State<EditorAttestation> {
  var _selectedMotif = MotifValue.list[0];
  var _birthdayDate = DateTime.now();
  var _selectedDate = DateTime.now();

  final _form = GlobalKey<FormState>();
  final _numberNode = FocusNode();
  final _addressNode = FocusNode();
  final _cpNode = FocusNode();
  final _cityNode = FocusNode();

  final _formData = {
    'name': '',
    'number': 0,
    'street': '',
    'cp': 0,
    'city': '',
    'birthday': DateTime.now(),
    'date': DateTime.now(),
    'motif': Map,
  };

  Map getData() {
    _form.currentState.save();
    _formData['motif'] = _selectedMotif;
    print('lskdjglksjdg lkfj  $_formData');

    return _formData;
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    // print('sdlfkgjdslkgjslkdgjlksdgjlksdgj  ${selectedMotif['short']}');

    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Form(
        key: _form,
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            SizedBox(height: h * 0.25),
            TextFormField(
              decoration: InputDecoration(labelText: "Mme/Mr"),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_numberNode),
              onSaved: (value) => _formData['name'] = value,
            ),
            SizedBox(height: 25.0),
            Text('Née le'),
            SizedBox(height: 25.0),
            Text('Adresse'),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "N°"),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _numberNode,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_addressNode),
                    onSaved: (value) => _formData['number'] = value,
                  ),
                ),
                SizedBox(width: 13.0),
                Flexible(
                  flex: 7,
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Rue"),
                    textInputAction: TextInputAction.next,
                    focusNode: _addressNode,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_cpNode),
                    onSaved: (value) => _formData['street'] = value,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Code Postale"),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _cpNode,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_cityNode),
                    onSaved: (value) => _formData['cp'] = value,
                  ),
                ),
                SizedBox(width: 13.0),
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Ville"),
                    textInputAction: TextInputAction.done,
                    focusNode: _cityNode,
                    onSaved: (value) => _formData['city'] = value,
                  ),
                ),
              ],
            ),
            Text('Motif :'),
            DropdownButton(
              isExpanded: true,
              hint: Text('${_selectedMotif['short']}'),
              items: MotifValue.list
                  .map<DropdownMenuItem<Map>>(
                    (Map e) => DropdownMenuItem<Map>(
                      value: e,
                      child: Text('${e['short']}'),
                    ),
                  )
                  .toList(),
              onChanged: (Map i) {
                //print('lskdjgslkdjg  $i $selectedMotif');
                setState(() {
                  _selectedMotif = i;
                });
              },
            ),
            Text(
              '${_selectedMotif['long']}',
              style: TextStyle(
                color: Colors.blueGrey[300],
                fontSize: 13.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
