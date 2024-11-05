import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../viewmodels/contact_viewmodel.dart';
import 'add_contact_page.dart';
import '../models/contact_model.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  bool _isSearching = false;
  String _searchText = '';

  Future<void> _pickContactFromPhone() async {
    if (await FlutterContacts.requestPermission()) {
      final contact = await FlutterContacts.openExternalPick();
      if (contact != null) {
        final phoneNumbersMap = <String, String>{};
      final lg = contact.phones.length;
      
      if(lg==1){
        final contactModel = ContactModel(
          firstName: contact.name.first,
          lastName: contact.name.last ,
          phoneNumbers: phoneNumbersMap,
          email: contact.emails.isNotEmpty ? contact.emails.first.address : '',
          isVerified: false,
        );
        Provider.of<ContactViewModel>(context, listen: false).addContact(contactModel);
      }

      else{
for (var phone in contact.phones) {
        // Use phone label if available, else default to 'Mobile'
        var label = phone.label.toString().substring(11);
        
        
        // Add the phone number with the format "name + label"
        phoneNumbersMap['$label'] = phone.number;


        final contactModel = ContactModel(
          firstName: contact.name.first,
          lastName: contact.name.last +' '+ label,
          phoneNumbers: phoneNumbersMap,
          email: contact.emails.isNotEmpty ? contact.emails.first.address : '',
          isVerified: false,
        );
        Provider.of<ContactViewModel>(context, listen: false).addContact(contactModel);
      }
      }
      // Iterate through each phone number
      

        
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Search Contacts',border: InputBorder.none,),
                onChanged: (query) {
                  setState(() => _searchText = query);
                  Provider.of<ContactViewModel>(context, listen: false).searchContact(query);
                },
              )
            : const Text("Team"),
            backgroundColor: const Color.fromARGB(255, 32, 101, 205),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Handle menu action
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => setState(() => _isSearching = !_isSearching),
          ),
        ],
      ),
      body: Consumer<ContactViewModel>(
        builder: (context, viewModel, child) {
          viewModel.searchContact(_searchText);
          return ListView.builder(
            itemCount: viewModel.filteredContacts.length,
            itemBuilder: (context, index) {
              final contact = viewModel.filteredContacts[index];
              return ListTile(
                title: Text('${contact.firstName} ${contact.lastName}'),
                onTap: () => _showVerifyContactDialog(context, viewModel, index),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog<ContactModel>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Contact'),
              content: const Text('Would you like to create or pick a contact?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _pickContactFromPhone();
                  },
                  child: const Text('Pick from Contacts'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddContactPage()),
                    );
                    if (result is ContactModel) {
                      Provider.of<ContactViewModel>(context, listen: false).addContact(result);
                    }
                  },
                  child: const Text('Create Manually'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showVerifyContactDialog(BuildContext context, ContactViewModel viewModel, int index) {
    final contact = viewModel.filteredContacts[index];

    if (contact.isVerified) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Already Verified'),
          content: const Text('This contact is already verified.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Verify Contact'),
          content: const Text('Are you sure you want to verify this contact?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                viewModel.verifyContact(index);
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      );
    }
  }
}
