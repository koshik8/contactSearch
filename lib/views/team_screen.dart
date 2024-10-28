import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/contact_viewmodel.dart';
import 'add_contact_page.dart';
import '../models/contact_model.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  bool _isSearching = false;
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search Contacts',
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  setState(() {
                    _searchText = query;
                  });
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
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
      ),
      body: Consumer<ContactViewModel>(
        builder: (context, viewModel, child) {
          viewModel.searchContact(_searchText); // Ensures contacts are filtered
          return ListView.builder(
            itemCount: viewModel.filteredContacts.length,
            itemBuilder: (context, index) {
              final contact = viewModel.filteredContacts[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(contact.firstName.isNotEmpty ? contact.firstName[0] : 'N'),
                ),
                title: Text('${contact.firstName} ${contact.lastName}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (contact.isVerified)
                      const Icon(Icons.verified_user, color: Color.fromARGB(255, 32, 101, 205)),
                    const Icon(Icons.call, color: Color.fromARGB(255, 32, 101, 205)),
                  ],
                ),
                onTap: () {
                  _showVerifyContactDialog(context, viewModel, index);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddContactPage()),
          );

          if (result is ContactModel) {
            // If the result is a ContactModel, add it to the view model
            // ignore: use_build_context_synchronously
            Provider.of<ContactViewModel>(context, listen: false).addContact(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showVerifyContactDialog(BuildContext context, ContactViewModel viewModel, int index) {
    final contact = viewModel.filteredContacts[index];

    if (contact.isVerified) {
      // Show alert that the contact is already verified
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
      // Show confirmation dialog for verification
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Verify Contact'),
          content: const Text('Do you want to verify this contact?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                viewModel.verifyContact(index);
                Navigator.pop(context);
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      );
    }
  }
}
