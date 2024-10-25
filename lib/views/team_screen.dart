    import 'package:flutter/material.dart';
    import 'package:provider/provider.dart';
    import '../viewmodels/contact_viewmodel.dart';
    import 'add_contact_page.dart';

    class TeamScreen extends StatefulWidget {
      @override
      _TeamScreenState createState() => _TeamScreenState();
    }

    class _TeamScreenState extends State<TeamScreen> {
      bool _isSearching = false;
      String _searchText = '';

      @override
      Widget build(BuildContext context) {
        return ChangeNotifierProvider(
          create: (_) => ContactViewModel(),
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: _isSearching
                  ? TextField(
                      autofocus: true,
                      decoration: InputDecoration(
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
                  // Handle 
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search), // Search icon
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching; // Toggle search state
                    });
                  },
                ),
              ],
            ),
            body: ContactList(searchText: _searchText), // Pass searchText to filter
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddContactPage()),
                );
                if (result == true) {
              
              setState(() {});
            }
              },
              child: const Icon(Icons.add),
            ),
          ),
        );
      }
    }

    class ContactList extends StatelessWidget {
      final String searchText;

      const ContactList({Key? key, required this.searchText}) : super(key: key);

      @override
      Widget build(BuildContext context) {
        final viewModel = Provider.of<ContactViewModel>(context);

        // Update filteredContacts based on searchText
        viewModel.searchContact(searchText);

        return ListView.builder(
          itemCount: viewModel.filteredContacts.length,
          itemBuilder: (context, index) {
            final contact = viewModel.filteredContacts[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Text(contact.firstName[0]),
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
      }

      void _showVerifyContactDialog(BuildContext context, ContactViewModel viewModel, int index) {
        final contact = viewModel.filteredContacts[index];

        if (contact.isVerified) {
          // Show alert that the contact is already verified
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Already Verified'),
              content: Text('This contact is already verified.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // Show confirmation dialog for verification
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Verify Contact'),
              content: Text('Do you want to verify this contact?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    viewModel.verifyContact(index);
                    Navigator.pop(context);
                  },
                  child: Text('Verify'),
                ),
              ],
            ),
          );
        }
      }
    }
