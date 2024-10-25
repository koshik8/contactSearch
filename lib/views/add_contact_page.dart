import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/contact_viewmodel.dart';
import '../models/contact_model.dart'; // Import the ContactModel
import 'package:permission_handler/permission_handler.dart';

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
  bool? ree = true;

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

  @override
  Widget build(BuildContext context) {
    final contactViewModel = Provider.of<ContactViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white, // Match background as in the images
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add New Contact',
          style: TextStyle(color: Colors.white, fontSize: 18), // Match text style in images
        ),
        backgroundColor: const Color(0xFF5676F5), // Blue color in image
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
                  phoneNumbers: {},
                ));
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('At least a first or last name is required.')),
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
            // Profile image section
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200], // Matches background color in the image
              child: const Icon(
                Icons.person,
                size: 50,
                color: Color(0xFF5676F5), // Use matching color for the icon
              ),
            ),
            const SizedBox(height: 20),
            // First name input
            TextField(
              decoration: InputDecoration(
                labelText: 'First Name',
                labelStyle: TextStyle(color: Colors.grey[600]), // Style matching the image
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded input fields
                ),
              ),
              onChanged: (value) {
                setState(() {
                  firstName = value;
                });
              },
            ),
            const SizedBox(height: 15 ),
            // Last name input
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
            const SizedBox(height: 15 ),
            // Phone number input
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
            const SizedBox(height: 15 ),
            // Email input
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
            // Pick contact button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300], // Gray background button in the image
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded button
                ),
                side: const BorderSide(color: Colors.grey), // Border around button
              ),
              onPressed: () async {
                await requestContactPermission();
                contactViewModel.pickContact();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: Colors.black), // Add icon
                  SizedBox(width: 10),
                  Text(
                    'Add Field',
                    style: TextStyle(color: Colors.black), // Black text for the button
                  ),
                ],
              ),
            ),
            const Spacer(), // Push 'Create' button to the bottom
            Row(
              children: [
                Checkbox(
                  
                  activeColor: const Color(0xFF5676F5), value: ree, onChanged: (bool? value) { setState(() {
                  ree = value ;
                }); },
                ),
                const Text('Save this into Phone contacts'),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5676F5), // Blue color for the button
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                if (firstName.isNotEmpty || lastName.isNotEmpty) {
                  contactViewModel.addContact(ContactModel(
                    firstName: firstName.isEmpty ? 'Unnamed' : firstName,
                    lastName: lastName.isEmpty ? '' : lastName,
                    phoneNumbers: {},

                  ));
                  Navigator.pop(context,true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('At least a first or last name is required.')),
                  );
                }
              },
              child: const Text('Create', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
