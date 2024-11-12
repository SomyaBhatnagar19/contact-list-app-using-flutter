// main.dart
import 'package:flutter/material.dart';
import 'screens/contact_list_page.dart';

void main() => runApp(ContactListApp());

class ContactListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact List App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ContactListPage(),
    );
  }
}
