import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/api_service.dart';
import 'edit_contact_screen.dart';
import '../widgets/contact_card.dart';

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final ApiService apiService = ApiService();
  late Future<List<Contact>> contactList;

  @override
  void initState() {
    super.initState();
    contactList = apiService.fetchContacts();
  }

  void _refreshContacts() {
    setState(() {
      contactList = apiService.fetchContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts')),
      body: FutureBuilder<List<Contact>>(
        future: contactList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final contacts = snapshot.data!;
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ContactCard(
                  contact: contact,
                  onEdit: () async {
                    final updatedContact = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditContactScreen(contact: contact),
                      ),
                    );
                    if (updatedContact != null) _refreshContacts();
                  },
                  onDelete: () async {
                    await apiService.deleteContact(contact.id);
                    _refreshContacts();
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
