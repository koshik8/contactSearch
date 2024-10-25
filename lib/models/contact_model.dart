class ContactModel {
  String firstName;
  String lastName;
  Map<String, String> phoneNumbers; // Maps phone numbers to labels
  String email; // New email field
  bool isVerified; // Track if the contact is verified
  String avatar; // Field for the avatar URL or default value

  ContactModel({
    required this.firstName,
    required this.lastName,
    required this.phoneNumbers,
    this.email = '',
    this.isVerified = false, // Default value
    this.avatar = '', // Default to empty string
  });
}
