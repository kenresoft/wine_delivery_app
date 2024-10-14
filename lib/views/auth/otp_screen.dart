import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../repository/auth_repository.dart';
import '../../utils/preferences.dart';
import '../home/main_screen.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Enter the OTP sent to your email.'),
            SizedBox(height: 50.h),
            PinEntry(
              onInputComplete: (pin) => _submitOtp(context, mounted, pin),
              middleWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text('Enter OTP'),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 24),
                          height: 46,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('Resend OTP'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _isLoading ? const CircularProgressIndicator() : const SizedBox(),
                  SizedBox(height: 148.h),
                ],
              ),
              centerMiddleWidget: true,
              pinLength: 6,
              inputFieldConfiguration: InputFieldConfiguration(obscureText: false),
              keyboardConfiguration: KeyboardConfiguration(flexibleButton: true),
            ),
            //Spacer(),
          ],
        ),
      ),
    );
  }

  void _submitOtp(BuildContext context, bool mounted, String pin) async {
    setState(() {
      _isLoading = true;
    });

    bool success = await authRepository.verifyOtp(widget.email, pin, (message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    });

    if (success && mounted) {
      otpSent = false;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
