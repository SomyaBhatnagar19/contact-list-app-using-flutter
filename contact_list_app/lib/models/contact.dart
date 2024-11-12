class Contact {

  // final -> means that once assigned a value it cant be changed
  final int id;
  final String name;
  final String phone;
  final String email;

  // constructor defining for instance creation of contact -> required used to make the data compulsary to be filled
  Contact({required this.id, required this.name, required this.phone, this.email = ''});


  // below is a factory constructor -> fromJSON : creates Contact object with JSON data from databse
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'] ?? '', // if email missing from db then it fills empty string 
    );
  }

  // toJson -> method to convert a contact object to JSON like Map (key, value pair)
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
  };
}
