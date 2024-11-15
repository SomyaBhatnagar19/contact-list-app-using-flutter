import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contact.dart';

class ApiService {
  static const String apiUrl = 'http://127.0.0.1:8000/api/contacts/';

  Future<List<Contact>> fetchContacts({String query = ''}) async {
    //Modifying for searching functionality
    //changing the url for it
    final response = await http.get(Uri.parse('$apiUrl?search=$query'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Contact.fromJson(data)).toList();
    } else {
      print('Failed to load contacts. Status code: ${response.statusCode}'); 
      print('Response body: ${response.body}'); 
      throw Exception('Failed to load contacts');
    }
  }

  Future<Contact> addContact(Contact contact) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(contact.toJson()),
    );
    if (response.statusCode == 201) {
      return Contact.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add contact');
    }
  }

  Future<void> deleteContact(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl$id/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete contact');
    }
  }

  // for updating
  Future<void> updateContact(int id, Contact contact) async {
    await http.put(
      Uri.parse('$apiUrl$id/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(contact.toJson()),
    );
  }
}
