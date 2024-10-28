import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/contact_viewmodel.dart';
import '../models/contact_model.dart';
import 'package:permission_handler/permission_handler.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  String firstName = '';
  String lastName = '';
  String phno = '';
  String email = '';
  bool? saveToPhoneContacts = true; // Renamed for clarity
  final List<Map<String, String>> customFields = []; // Store additional fields

  @override
  void initState() {
    super.initState();
    requestContactPermission();
  }

  Future<void> requestContactPermission() async {
    PermissionStatus status = await Permission.contacts.status;
    if (!status.isGranted) {
      await Permission.contacts.request();
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
                    // Show an error message if fields are empty
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
                onChanged: (value) {
                  fieldName = value;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration:  InputDecoration(labelText: 'Field Value',border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  borderSide: const BorderSide(color: Colors.grey), // Border color
                ),),
                onChanged: (value) {
                  fieldValue = value;
                },
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
          title: const Text(
            'Add New Contact',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          backgroundColor: const Color(0xFF5676F5),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: () {
                if (firstName.isNotEmpty || lastName.isNotEmpty) {
                  contactViewModel.addContact(ContactModel(
                    firstName: firstName.isEmpty ? 'Unnamed' : firstName,
                    lastName: lastName.isEmpty ? '' : lastName,
                    phoneNumbers: {'Mobile': phno},
                    email: email,
                    isVerified:
                        false, // Set newly created contact to not verified
                    // Adding custom fields to the contact if needed
                  ));
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
              TextField(
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    firstName = value;
                  });
                },
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
                onChanged: (value) {
                  setState(() {
                    lastName = value;
                  });
                },
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
                onChanged: (value) {
                  setState(() {
                    phno = value;
                  });
                },
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
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Dynamic fields added here
              ...customFields.map((field) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
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
                      // You can handle the value of the custom fields here if needed
                    },
                  ),
                );
              // ignore: unnecessary_to_list_in_spreads
              }).toList(),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  side: const BorderSide(color: Colors.grey),
                ),
                onPressed: () {
                  _addCustomField(); // Call the method to show dialog
                },
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
                    onChanged: (bool? value) {
                      setState(() {
                        saveToPhoneContacts = value;
                      });
                    },
                  ),
                  const Text('Save this into Phone contacts'),
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
                onPressed: () {
                  if (firstName.isNotEmpty || lastName.isNotEmpty) {
                    final newContact = ContactModel(
                      firstName: firstName.isEmpty ? 'Unnamed' : firstName,
                      lastName: lastName.isEmpty ? '' : lastName,
                      phoneNumbers: {'Mobile': phno},
                      email: email,
                      isVerified: false, // Ensure the contact is not verified
                    );
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
