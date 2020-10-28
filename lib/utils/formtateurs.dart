import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Formats {
  static String date(DateTime d) => '${DateFormat('dd.MM.yyyy').format(d)}';

  static String heure(TimeOfDay t) => '${t.hour}:${t.minute}';
}
