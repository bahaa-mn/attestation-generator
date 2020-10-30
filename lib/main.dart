import 'package:flutter/material.dart';

import './screens/editor_screen.dart';
import './screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Générateur d\'attestation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Home.routeName,
      routes: {
        Home.routeName: (context) => Home(),
        EditorScreen.routeName: (context) => EditorScreen(),
      },
    );
  }
}
