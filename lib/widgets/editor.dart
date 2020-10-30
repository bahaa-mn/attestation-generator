import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/formtateurs.dart';

class EditorAttestation extends StatefulWidget {
  final Map m;
  final state = _EditorAttestationState();

  EditorAttestation({this.m});

  @override
  _EditorAttestationState createState() => state;
}

class _EditorAttestationState extends State<EditorAttestation> {
  var isModify = false;
  var _selectedMotif = MotifValue.list[0];

  var _selectedBirthDate = DateTime.now();
  var _selectedDate = DateTime.now();
  var _selectedHeure = TimeOfDay.now();

  final _form = GlobalKey<FormState>();
  // final _birthDateNode = FocusNode();
  final _birthCityNode = FocusNode();
  final _addressNode = FocusNode();
  // final _dateNode = FocusNode();
  // final _heureNode = FocusNode();
  final _cityNode = FocusNode();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthCityController = TextEditingController();
  final _cityController = TextEditingController();

  final _formData = {
    MapAttrs.name: '',
    MapAttrs.addresse: '',
    MapAttrs.birthday: DateTime.now(),
    MapAttrs.birthCity: '',
    MapAttrs.city: '',
    MapAttrs.date: DateTime.now(),
    MapAttrs.heure: TimeOfDay.now(),
    MapAttrs.motif: Map,
    MapAttrs.lastModif: DateTime.now(),
  };

  final inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(7.0),
    borderSide: BorderSide(width: 1.0),
  );

  @override
  void initState() {
    Map m = widget.m;

    if (m != null) {
      _nameController.text = m[MapAttrs.name];
      _addressController.text = m[MapAttrs.addresse];
      _birthCityController.text = m[MapAttrs.birthCity];
      _cityController.text = m[MapAttrs.city];
      _selectedMotif = m[MapAttrs.motif];
      _selectedBirthDate = m[MapAttrs.birthday];
      _selectedDate = m[MapAttrs.date];
      _selectedHeure = m[MapAttrs.heure];
    } else {
      _nameController.text = '';
      _addressController.text = '';
      _birthCityController.text = '';
      _cityController.text = '';
      _selectedBirthDate = DateTime.now();
      _selectedDate = DateTime.now();
      _selectedHeure = TimeOfDay.now();
      // _dateController.text =
      //     '${DateFormat('dd.MM.yyyy').format(DateTime.now())}';
      // _heureController.text = '${DateFormat('HH:mm').format(DateTime.now())}';
    }
    super.initState();
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
            SizedBox(height: h * 0.1),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Mme/Mr",
                border: inputBorder,
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_birthCityNode),
              onSaved: (value) => _formData[MapAttrs.name] = value,
              validator: _validField,
            ),
            SizedBox(height: 7.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Text(
                    'Né(e) le :',
                    style: TextStyle(),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: TextButton(
                    child: Text(Formats.date(_selectedBirthDate)),
                    onPressed: () async {
                      final currYear = DateTime.now().year;
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedBirthDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(currYear + 1),
                      );
                      if (date == null) return;
                      setState(() {
                        _selectedBirthDate = date;
                      });
                    },
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: TextFormField(
                    controller: _birthCityController,
                    decoration: InputDecoration(
                      labelText: 'à',
                      hintText: 'Ville',
                      border: inputBorder,
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: _birthCityNode,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_addressNode),
                    onSaved: (value) => _formData[MapAttrs.birthCity] = value,
                    validator: _validField,
                  ),
                ),
              ],
            ),
            SizedBox(height: 7.0),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: "Adresse",
                border: inputBorder,
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              focusNode: _addressNode,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_cityNode),
              onSaved: (value) => _formData[MapAttrs.addresse] = value,
              validator: _validField,
            ),
            SizedBox(height: 7.0),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Fait à',
                hintText: 'Ville',
                border: inputBorder,
              ),
              focusNode: _cityNode,
              textInputAction: TextInputAction.done,
              // onFieldSubmitted: (_) =>
              //     FocusScope.of(context).requestFocus(_dateNode),
              onSaved: (value) => _formData[MapAttrs.city] = value,
              validator: _validField,
            ),
            SizedBox(height: 7.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      'Date',
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      'Heure',
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: TextButton(
                      child: Text(Formats.date(_selectedDate)),
                      onPressed: () async {
                        final currYear = DateTime.now().year;
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(currYear + 1),
                        );
                        if (date == null) return;
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: TextButton(
                      child: Text(Formats.heure(_selectedHeure)),
                      onPressed: () async {
                        final hour = await showTimePicker(
                          context: context,
                          initialTime: _selectedHeure,
                        );
                        if (hour == null) return;
                        setState(() {
                          _selectedHeure = hour;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 7.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(flex: 1, child: Text('Motif')),
                Flexible(
                  flex: 5,
                  child: DropdownButton(
                    value: _selectedMotif,
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
                ),
              ],
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

  String _validField(String value) =>
      value.length == 0 ? 'Ce champs est obligatoire' : null;

  bool isFormValid() {
    if (_form == null) {
      Navigator.of(context).pop();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Une erreur est survenue, veuillez réessayer.',
            style: TextStyle(
              color: Colors.redAccent,
            ),
          ),
          backgroundColor: Colors.white,
        ),
      );
      return false;
    }
    return _form.currentState.validate();
  }

  Map getData() {
    _form.currentState.save();
    _formData[MapAttrs.motif] = _selectedMotif;
    _formData[MapAttrs.date] = _selectedDate;
    _formData[MapAttrs.heure] = _selectedHeure;
    _formData[MapAttrs.birthday] = _selectedBirthDate;

    _formData[MapAttrs.lastModif] = DateTime.now();

    // print('lskdjglksjdg lkfj  $_formData');

    return _formData;
  }
}
