import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../viewmodels/contact_viewmodel.dart';
import '../models/contact_model.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  String firstName = '';
  String lastName = '';
  String phno = '';
  String email = '';
  bool? saveToPhoneContacts = true;
  final List<Map<String, String>> customFields = [];

  @override
  void initState() {
    super.initState();
    requestContactPermission();
  }

  Future<void> requestContactPermission() async {
    if (!await FlutterContacts.requestPermission()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contacts permission denied.')),
      );
    }
  }

  void _addCustomField() {
    showDialog(
      context: context,
      builder: (context) {
        String fieldName = '';
        String fieldValue = '';

        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Add Field'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 11, 43, 90),
              fontWeight: FontWeight.w700,
              fontSize: 25.0),
          actions: [
            Center(
              child: TextButton(
                 style: TextButton.styleFrom(backgroundColor: const Color.fromARGB(255, 11, 43, 90),textStyle: const TextStyle(fontWeight: FontWeight.bold,color:Colors.white) ),
                onPressed: () {
                  if (fieldName.isNotEmpty && fieldValue.isNotEmpty) {
                    setState(() {
                      customFields.add({'name': fieldName, 'value': fieldValue});
                    });
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Both fields are required.')),
                    );
                  }
                },
                child: const Text('OK'),
              ),
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Field Name',border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  borderSide: const BorderSide(color: Colors.grey), // Border color
                ),),
                onChanged: (value) => fieldName = value,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration:  InputDecoration(labelText: 'Field Value',border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  borderSide: const BorderSide(color: Colors.grey), // Border color
                ),),
                onChanged: (value) => fieldValue = value,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final contactViewModel =
        Provider.of<ContactViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add New Contact',style: TextStyle(color: Colors.white, fontSize: 18),),
         backgroundColor: const Color(0xFF5676F5),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              if (firstName.isNotEmpty || lastName.isNotEmpty) {
                final newContact = ContactModel(
                  firstName: firstName.isEmpty ? 'Unnamed' : firstName,
                  lastName: lastName,
                  phoneNumbers: {'Mobile': phno},
                  email: email,
                  isVerified: false,
                );

                if (saveToPhoneContacts == true) {
                  final flutterContact = Contact()
                    ..name.first = newContact.firstName
                    ..name.last = newContact.lastName
                    ..phones = [Phone(phno)]
                    ..emails = [Email(email)];

                  await FlutterContacts.insertContact(flutterContact);
                }

                contactViewModel.addContact(newContact);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('At least a first or last name is required.')),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Color(0xFF5676F5),
                ),
              ),
              const SizedBox(height: 20),

            // Basic fields
            TextField(
              decoration: InputDecoration(labelText: 'First Name',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),),
              onChanged: (value) => setState(() => firstName = value),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              onChanged: (value) => setState(() => lastName = value),
            ),
            const SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              onChanged: (value) => setState(() => phno = value),
            ),
            const SizedBox(height: 15),
           TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),

              onChanged: (value) => setState(() => email = value),
            ),
            const SizedBox(height: 15),

            // Custom fields
            ...customFields.map((field) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: '${field['name']}',
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  onChanged: (value) {
                    field['value'] = value;
                  },
                ),
              );
            }).toList(),

            const SizedBox(height: 15),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  side: const BorderSide(color: Colors.grey),
                ),
              onPressed: _addCustomField,
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Add Field', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              const Spacer(),
            
            Row(
              children: [
                Checkbox(
                  activeColor: const Color(0xFF5676F5),
                  value: saveToPhoneContacts,
                  onChanged: (value) =>
                      setState(() => saveToPhoneContacts = value),
                ),
                const Text('Save to Phone Contacts'),
              ],
            ),
          ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5676F5),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () async {
                  if (firstName.isNotEmpty || lastName.isNotEmpty) {
                    final newContact = ContactModel(
                      firstName: firstName.isEmpty ? 'Unnamed' : firstName,
                      lastName: lastName.isEmpty ? '' : lastName,
                      phoneNumbers: {'Mobile': phno},
                      email: email,
                      isVerified: false, // Ensure the contact is not verified
                    );
                    if (saveToPhoneContacts == true) {
                  final flutterContact = Contact()
                    ..name.first = newContact.firstName
                    ..name.last = newContact.lastName
                    ..phones = [Phone(phno)]
                    ..emails = [Email(email)];

                  await FlutterContacts.insertContact(flutterContact);
                }

                contactViewModel.addContact(newContact);
                    Navigator.pop(context, newContact); // Pass back the contact
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'At least a first or last name is required.')),
                    );
                  }
                },
                child:
                    const Text('Create', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ));
  }
}
  
