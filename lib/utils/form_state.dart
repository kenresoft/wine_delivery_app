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

  @override
  bool validate() {
    if (fullNameController.text.isEmpty) {}

    return true; // Return true if all fields are valid
  }
}
