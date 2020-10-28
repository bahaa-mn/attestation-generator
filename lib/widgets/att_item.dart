import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/constants.dart';
import '../utils/formtateurs.dart';

class AttestationItem extends StatelessWidget {
  final Map attestation;

  AttestationItem({this.attestation}) : assert(attestation != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(5.0),
      ),
      height: 75,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              width: double.infinity,
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${Formats.date(attestation[MapAttrs.date])}',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AutoSizeText(
                    '${attestation[MapAttrs.motif]['short']}',
                    maxLines: 1,
                  ),
                  AutoSizeText(
                    '${attestation[MapAttrs.name]}',
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              width: double.infinity,
              alignment: Alignment.bottomRight,
              child: Text(
                'Dernière modification : ${DateFormat("dd.MM.yyyy - HH:mm").format(attestation[MapAttrs.lastModif])}',
                style: TextStyle(fontSize: 11.0),
              ),
            ),
          ),
        ],
      ),
      // child: ListTile(
      //   title: Text('${Formats.date(attestation[MapAttrs.date])}'),
      //   subtitle: Text('${attestation[MapAttrs.motif]['short']}'),

      // ),
    );
  }
}
