import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/api_service.dart';

class AddContactScreen extends StatefulWidget {
  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();


  // Function to add the contact
  Future<void> _addContact() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty || _emailController.text.isEmpty) {
      // Show a snackbar if the fields are empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    // Create a new contact object
    final newContact = Contact(
      id: 0, // Backend will assign an ID
      name: _nameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
    );

    // Call the API to add the contact
    await apiService.addContact(newContact);

    // Return the new contact to the previous screen
    Navigator.pop(context, newContact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Contact'),

      ),
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
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addContact,
              child: Text('Save Contact'),
            ),
          ],
        ),
      ),
    );
  }
}
