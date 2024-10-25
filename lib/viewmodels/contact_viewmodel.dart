import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/contact_model.dart';

class ContactViewModel extends ChangeNotifier {
  List<ContactModel> contacts = [
    ContactModel(firstName: 'Aaditya', lastName: 'Anand Sir', phoneNumbers: {}),
    ContactModel(firstName: 'Anand', lastName: 'Rajamani', phoneNumbers: {}, isVerified: true),
    ContactModel(firstName: 'Anand', lastName: 'Sir Test', phoneNumbers: {}),
    ContactModel(firstName: 'Deva', lastName: '', phoneNumbers: {}),
  ];

  List<ContactModel> filteredContacts = [];
  String searchText = '';

  ContactViewModel() {
    filteredContacts = contacts;
  }

  void searchContact(String query) {
    searchText = query;
    filteredContacts = contacts
        .where((contact) =>
            ('${contact.firstName} ${contact.lastName}').toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void verifyContact(int index) {
    contacts[index].isVerified = true;
    searchContact(searchText); // Update filtered list
  }



Future<void> pickContact() async {
  // Request contacts permission
  if (await Permission.contacts.request().isGranted) {
    // Use `contacts_service` to pick a contact from the phone's address book
    Iterable<Contact> contacts = await ContactsService.getContacts();
    
    if (contacts.isNotEmpty) {
      Contact selectedContact = contacts.first; 

      var newContact = ContactModel(
        firstName: selectedContact.givenName ?? '',
        lastName: selectedContact.familyName ?? '',
        phoneNumbers: {for (var phone in selectedContact.phones ?? []) phone.label ?? 'Other': phone.value ?? ''},
      );
      this.contacts.add(newContact);
      searchContact(searchText);  // Update your search functionality
      notifyListeners();          // Update listeners
    }
  } else {
    // Handle 
    
  }
}


  void addContact(ContactModel contact) {
  contacts.add(contact);
  searchContact(searchText); // Update the search results
  notifyListeners(); // Notify listeners about changes
}

}
