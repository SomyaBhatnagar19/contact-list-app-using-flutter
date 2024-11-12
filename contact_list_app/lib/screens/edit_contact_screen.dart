import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/api_service.dart';

class EditContactScreen extends StatefulWidget {
  final Contact contact;

  EditContactScreen({required this.contact});

  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  final ApiService apiService = ApiService();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact.name);
    _phoneController = TextEditingController(text: widget.contact.phone);
  }

  Future<void> _saveContact() async {
    final updatedContact = Contact(
      id: widget.contact.id,
      name: _nameController.text,
      phone: _phoneController.text,
    );
    await apiService.updateContact(updatedContact);
    Navigator.pop(context, updatedContact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Contact')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveContact,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}