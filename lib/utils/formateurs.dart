import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'constants.dart';

class Formats {
  static String date(DateTime d) => '${DateFormat('dd/MM/yyyy').format(d)}';

  static String heure(TimeOfDay t) =>
      '${NumberFormat('00').format(t.hour)}:${NumberFormat('00').format(t.minute)}';

  static String fileName(Map data) =>
      '${data[MapAttrs.motif]['short'].toString().toLowerCase().substring(0, 3)}${data[MapAttrs.name].toString().substring(0, 3).toLowerCase()}_${Formats.date(data[MapAttrs.date]).replaceAll('.', '')}${Formats.heure(data[MapAttrs.heure]).replaceAll(':', '')}';
}
