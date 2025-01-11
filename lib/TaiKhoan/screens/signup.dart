import 'package:flutter/material.dart';
import '../../services/tab_repository.dart';
import '../theme.dart';
import 'login.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 130),
            Padding(
              padding: kDefaultPadding,
              child: Text(
                'Tạo mới tài khoản',
                style: titleText,
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: kDefaultPadding,
              child: Row(
                children: [
                  Text('Bạn đã có tài khoản?', style: subTitle),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LogInScreen()),
                      );
                    },
                    child: Text(
                      'Đăng nhập',
                      style: textButton.copyWith(
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: kDefaultPadding,
              child: SignUpForm(),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final TabRepository _tabRepository = TabRepository();  // Create an instance of TabRepository

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email không được bỏ trống';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Hãy nhập email hợp lệ';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được bỏ trống';
    } else if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự.';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return 'Mật khẩu không khớp.';
    }
    return null;
  }

  Future<void> _submitSignUpForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        String firstName = firstNameController.text;
        String lastName = lastNameController.text;
        String email = emailController.text;
        String password = passwordController.text;

        Map<String, dynamic> result = await _tabRepository.signUp(
          email,
          password,
          firstName,
          lastName,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tạo mới tài khoản thành công!')),
        );

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LogInScreen()),
          );
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-up failed: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          InputFormField(
            controller: firstNameController,
            hint: 'Tên',
            isPassword: false,
            validator: (value) =>
            value!.isEmpty ? 'Tên không được bỏ trống' : null,
          ),
          InputFormField(
            controller: lastNameController,
            hint: 'Họ',
            isPassword: false,
            validator: (value) =>
            value!.isEmpty ? 'Họ không được bỏ trống' : null,
          ),
          InputFormField(
            controller: emailController,
            hint: 'Email',
            isPassword: false,
            validator: validateEmail,
          ),
          InputFormField(
            controller: passwordController,
            hint: 'Mật kẩu',
            isPassword: true,
            isObscure: _isObscure,
            toggleObscure: () => setState(() => _isObscure = !_isObscure),
            validator: validatePassword,
          ),
          InputFormField(
            controller: confirmPasswordController,
            hint: 'Nhập lại mật khẩu',
            isPassword: true,
            isObscure: _isObscure,
            toggleObscure: () => setState(() => _isObscure = !_isObscure),
            validator: validateConfirmPassword,
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.08,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: kPrimaryColor,
            ),
            child: TextButton(
              onPressed: _submitSignUpForm,
              child: Text(
                "Đăng ký",
                style: textButton.copyWith(color: kWhiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InputFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isPassword;
  final bool? isObscure;
  final VoidCallback? toggleObscure;
  final String? Function(String?)? validator;

  const InputFormField({
    required this.controller,
    required this.hint,
    required this.isPassword,
    this.isObscure,
    this.toggleObscure,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? isObscure! : false,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: kTextFieldColor),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
          ),
          suffixIcon: isPassword
              ? IconButton(
            onPressed: toggleObscure,
            icon: Icon(
              isObscure! ? Icons.visibility_off : Icons.visibility,
              color: isObscure! ? kTextFieldColor : kPrimaryColor,
            ),
          )
              : null,
        ),
      ),
    );
  }
}
