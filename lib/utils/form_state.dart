import 'package:flutter/material.dart';

class ShipmentFormState extends FormState {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  // ... other form fields and methods

  @override
  bool validate() {
    // Validate all form fields here
    if (fullNameController.text.isEmpty) {
      // ... handle validation error for first name
    }
    // ... validate other fields

    return true; // Return true if all fields are valid
  }

// ... other methods like reset, save, etc.
}
