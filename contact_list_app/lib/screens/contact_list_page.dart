import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/api_service.dart';
import 'edit_contact_screen.dart';
import 'add_contact_screen.dart'; 
import '../widgets/contact_card.dart';

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
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

  Future<void> _navigateToAddContact() async {
    final newContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddContactScreen(),
      ),
    );
    if (newContact != null) {
      print("New contact added: $newContact");
      _refreshContacts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Contacts...',
                      hintText: 'Search by name or phone',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 11, 0, 0),
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  color: const Color.fromARGB(255, 90, 89, 89),
                  onPressed: () {
                    print('Search for: ${_searchController.text}');
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            color: const Color.fromARGB(255, 15, 14, 14),
            onPressed: _navigateToAddContact,
            tooltip: 'Add New Contact',
          ),
        ],
      ),
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
