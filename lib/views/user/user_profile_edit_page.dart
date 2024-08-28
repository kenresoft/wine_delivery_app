import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wine_delivery_app/model/product.dart';
import 'package:wine_delivery_app/repository/user_repository.dart';
import 'package:wine_delivery_app/utils/constants.dart';

import '../home/home_screen.dart';

class UserProfileEditPage extends StatefulWidget {
  final Profile profile;

  const UserProfileEditPage({super.key, required this.profile});

  @override
  State<UserProfileEditPage> createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController countryController;
  late TextEditingController zipCodeController;
  late TextEditingController bioController;
  File? _profileImage; // To store the profile image

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.username);
    emailController = TextEditingController(text: widget.profile.email);
    phoneController = TextEditingController();
    addressController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    countryController = TextEditingController();
    zipCodeController = TextEditingController();
    bioController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    zipCodeController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return const HomeScreen();
            },
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) {
                  return const HomeScreen(); // Because of the bottom nav we used
                },
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFFFAF9F6),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 5,
            color: Colors.white,
            surfaceTintColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildProfileImage(),
                    const SizedBox(height: 24),
                    const Text(
                      'Edit Your Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff394346),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(nameController, 'Full Name', 'Enter your full name', TextInputType.name),
                    const SizedBox(height: 16),
                    _buildTextField(emailController, 'Email', 'Enter your email address', TextInputType.emailAddress, validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    }),
                    const SizedBox(height: 16),
                    _buildTextField(phoneController, 'Phone Number', 'Enter your phone number', TextInputType.phone, validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    }),
                    const SizedBox(height: 16),
                    _buildTextField(addressController, 'Address', 'Enter your address', TextInputType.streetAddress),
                    const SizedBox(height: 16),
                    _buildTextField(cityController, 'City', 'Enter your city', TextInputType.text),
                    const SizedBox(height: 16),
                    _buildTextField(stateController, 'State', 'Enter your state', TextInputType.text),
                    const SizedBox(height: 16),
                    _buildTextField(countryController, 'Country', 'Enter your country', TextInputType.text),
                    const SizedBox(height: 16),
                    _buildTextField(zipCodeController, 'Zip Code', 'Enter your zip code', TextInputType.number),
                    const SizedBox(height: 16),
                    _buildTextField(bioController, 'Bio', 'Tell us about yourself', TextInputType.multiline, maxLines: 4),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() == true) {
                        await userRepository.updateUserProfile(
                          userId: widget.profile.id,
                          updatedData: {
                            "username": nameController.text,
                            "email": emailController.text,
                          },
                          profileImage: _profileImage,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile updated successfully')),
                        );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: const Color(0xffe0e0e0),
          backgroundImage: _profileImage != null
              ? FileImage(_profileImage!)
              : Image(
                  image: NetworkImage(Constants.baseUrl + widget.profile.profileImage),
                ).image,
          child: _profileImage == null
              ? const Icon(
                  CupertinoIcons.person_circle,
                  size: 80,
                  color: Color(0xff8c8c8c),
                )
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(
                CupertinoIcons.camera,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText,
    String hintText,
    TextInputType inputType, {
    FormFieldValidator<String>? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      keyboardType: inputType,
      validator: validator,
      maxLines: maxLines,
    );
  }
}
