import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/primary_button.dart';
import 'login.dart';
import 'package:tlubook/services/tab_repository.dart'; // Import the repository

class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TabRepository _tabRepository = TabRepository(); // Initialize TabRepository

  void _resetPassword(BuildContext context) async {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an email address')),
      );
      return;
    }

    try {
      await _tabRepository.resetPassword(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LogInScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: kDefaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 250),
            Text(
              'Reset Password',
              style: titleText,
            ),
            SizedBox(height: 5),
            Text(
              'Please enter your email address',
              style: subTitle.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            // Update ResetForm to use the controller
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: kTextFieldColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () => _resetPassword(context), // Trigger reset password
              child: PrimaryButton(buttonText: 'Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
