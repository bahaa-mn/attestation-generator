import 'package:acfgen/utils/constants.dart';
import 'package:acfgen/utils/formtateurs.dart';
import 'package:flutter/material.dart';

class AttestationItem extends StatelessWidget {
  final Map attestation;

  AttestationItem({this.attestation}) : assert(attestation != null);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${Formats.date(attestation[MapAttrs.date])}'),
        subtitle: Text('${attestation[MapAttrs.motif]['short']}'),
      ),
    );
  }
}
