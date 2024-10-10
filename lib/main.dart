import 'package:flutter/material.dart';
import 'package:flutter_api/screen/view_characters_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Posts App',
      home: ViewCharactersPage(),
    );
  }
}
