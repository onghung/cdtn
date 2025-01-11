import 'package:flutter/material.dart';
import 'package:tlubook/TaiKhoan/screens/reset_password.dart';
import 'package:tlubook/TaiKhoan/screens/signup.dart';
import 'package:tlubook/views/ADMIN/Base_screen_admin.dart';
import '../../services/tab_repository.dart';
import '../../views/home/base_screens.dart';
import '../../views/home/book_home.dart';
import '../theme.dart';


class LogInScreen extends StatefulWidget {
  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TabRepository _repository = TabRepository();

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: kDefaultPadding,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 220),
                Text('Mừng trở lại', style: titleText),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text('Bạn chưa có tài khoản?', style: subTitle),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                      child: Text(
                        'Đăng ký',
                        style: textButton.copyWith(
                          decoration: TextDecoration.underline,
                          decorationThickness: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                buildInputForm('Email', false, emailController, (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                }),
                buildInputForm('Password', true, passwordController, (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  return null;
                }),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
                    );
                  },
                  child: Text(
                    'Quên mật khẩu?',
                    style: TextStyle(
                      color: kZambeziColor,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationThickness: 1,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    if(emailController.text=="admin@gmail.com"){
                      if (_formKey.currentState?.validate() ?? false) {
                        try {
                          await _repository.login(
                            emailController.text,
                            passwordController.text,
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => BaseScreenADM()),
                          );
                        } catch (error) {
                          // Xử lý lỗi đăng nhập
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Lỗi'),
                              content: Text('Thông tin tài khoản hoặc mật khẩu không chính xác. Vui lòng thử lại.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Đóng'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    } else {
                      if (_formKey.currentState?.validate() ?? false) {
                        try {
                          await _repository.login(
                            emailController.text,
                            passwordController.text,
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => BaseScreen()),
                          );
                        } catch (error) {
                          // Xử lý lỗi đăng nhập
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Lỗi'),
                              content: Text('Thông tin tài khoản hoặc mật khẩu không chính xác. Vui lòng thử lại.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Đóng'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: kPrimaryColor,
                    ),
                    child: Text(
                      "Đăng nhâp",
                      style: textButton.copyWith(color: kWhiteColor),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildInputForm(String label, bool pass, TextEditingController controller, String? Function(String?)? validator) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        obscureText: pass ? _isObscure : false,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: kTextFieldColor),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
          ),
          suffixIcon: pass
              ? IconButton(
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
            icon: _isObscure
                ? Icon(Icons.visibility_off, color: kTextFieldColor)
                : Icon(Icons.visibility, color: kPrimaryColor),
          )
              : null,
        ),
        validator: validator, // Thêm kiểm tra tại đây
      ),
    );
  }
}

