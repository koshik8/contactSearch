import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TeamScreen(),
    );
  }
}

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  List<Map<String, dynamic>> contacts = [
    {'name': 'Aaditya Anand Sir', 'avatar': '', 'isVerified': false},
    {'name': 'Anand Rajamani', 'avatar': '', 'isVerified': true},
  ];

  List<Map<String, dynamic>> filteredContacts = [];
  String searchText = '';
  bool isSearching = false; // To tracks if search mode is enabled

  @override
  void initState() {
    super.initState();
    filteredContacts = contacts;
  }

  void _searchContact(String query) {
    setState(() {
      searchText = query;
      filteredContacts = contacts
          .where((contact) =>
              contact['name'].toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void _addContact(String name) {
    setState(() {
      contacts.add({'name': name, 'avatar': '', 'isVerified': false});
      filteredContacts = contacts;
    });
  }

  void _verifyContact(int index) {
    setState(() {
      contacts[index]['isVerified'] = true;
      filteredContacts = contacts;
    });
  }

  void _showAddContactDialog() {
    String newName = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Contact'),
        content: TextField(
          decoration: const InputDecoration(hintText: 'Enter contact name'),
          onChanged: (value) {
            newName = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (newName.isNotEmpty) {
                _addContact(newName);
              }
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showVerifyContactDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verify Contact'),
        content: const Text('Do you want to verify this contact?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _verifyContact(index); 
              Navigator.pop(context);
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  void _showVerifyContactDialog1( ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact already verified'),
        actions: [TextButton(
            onPressed: () {
              Navigator.pop(context); 
            },
            child: const Text('Ok'),
          ),],),);}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: !isSearching
            ? const Text("Team")
            : TextField(
                onChanged: _searchContact,
                decoration: const InputDecoration(
                  hintText: 'Search contacts...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.cancel : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  filteredContacts = contacts;
                }
              });
            },
          ),
        ],
        leading: IconButton(
          onPressed: () {
            //nothing
          },
          icon: const Icon(Icons.menu),
        ),
        backgroundColor: const Color.fromARGB(255, 32, 101, 205),
      ),
      body: ListView.builder(
        itemCount: filteredContacts.length,
        itemBuilder: (context, index) {
          final contact = filteredContacts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Text(
                contact['name'][0], 
                style: const TextStyle(color: Colors.black),
              ),
            ),
            title: Text(contact['name']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (contact['isVerified']) ...[
                  const Icon(
                    Icons.verified_user,
                    color: Color.fromARGB(255, 32, 101, 205),
                  ),
                  const SizedBox(width: 8),
                ],
                const Icon(
                  Icons.call,
                  color: Color.fromARGB(255, 32, 101, 205),
                ),
              ],
            ),
            onTap: () {
              (!contact['isVerified'])?
              _showVerifyContactDialog(index) :
              _showVerifyContactDialog1() ;
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
