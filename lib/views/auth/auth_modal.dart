import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wine_delivery_app/repository/auth_repository.dart';
import 'package:wine_delivery_app/views/auth/auth_button.dart';

import '../product/order/shipping_form_address.dart';

class AuthModal extends StatefulWidget {
  const AuthModal({super.key});

  @override
  State<AuthModal> createState() => _AuthModalState();
}

class _AuthModalState extends State<AuthModal> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      surfaceTintColor: const Color(0xFFFAF9F6),
      backgroundColor: const Color(0xFFFAF9F6),
      elevation: 4,
      child: PopScope(
        canPop: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Align(alignment: Alignment.centerRight, child: Icon(CupertinoIcons.xmark)),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff394346),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'First Name',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      // Toggle password visibility
                    },
                    icon: const Icon(Icons.visibility),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle create account button tap
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ShippingAddressForm(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(260, 52),
                  backgroundColor: colorScheme(context).primary,
                ),
                child: const Text('Create Account'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Or continue with:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  const AuthButton(
                    icon: Icon(CupertinoIcons.globe),
                    text: 'Continue with Google',
                  ),
                  const SizedBox(height: 10),
                  const AuthButton(
                    icon: Icon(Icons.facebook),
                    text: 'Continue with Facebook',
                  ),
                  const SizedBox(height: 10),
                  const AuthButton(
                    icon: Icon(Icons.apple),
                    text: 'Continue with Apple',
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Existing customer? ',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () async {
                          // Implement sign-in navigation logic
                          await authRepository.login(
                            emailController.text,
                            passwordController.text,
                            (value) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(value)),
                              );
                            },
                          );
                        },
                        child: const Text(
                          'Sign in',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'By creating an account, I agree to the Terms of Service and Privacy Policy.',
                    style: TextStyle(fontSize: 12.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ColorScheme colorScheme(BuildContext context) => Theme.of(context).colorScheme;
}
