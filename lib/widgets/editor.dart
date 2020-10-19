import 'package:acfgen/utils/constants.dart';
import 'package:flutter/material.dart';

class EditorAttestation extends StatefulWidget {
  final state = _EditorAttestationState();

  @override
  _EditorAttestationState createState() => state;
}

class _EditorAttestationState extends State<EditorAttestation> {
  var selectedMotif = MotifValue.list[0];

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    // print('sdlfkgjdslkgjslkdgjlksdgjlksdgj  ${selectedMotif['short']}');

    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Form(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            SizedBox(height: h * 0.25),
            TextFormField(
              decoration: InputDecoration(labelText: "Mme/Mr"),
              textInputAction: TextInputAction.next,
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
                  ),
                ),
                SizedBox(width: 13.0),
                Flexible(
                  flex: 7,
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Rue"),
                    textInputAction: TextInputAction.next,
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
                  ),
                ),
                SizedBox(width: 13.0),
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Ville"),
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
            Text('Motif :'),
            DropdownButton(
              isExpanded: true,
              hint: Text('${selectedMotif['short']}'),
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
                  selectedMotif = i;
                });
              },
            ),
            Text(
              '${selectedMotif['long']}',
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
