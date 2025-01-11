import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker package
import 'dart:io'; // To use File for image selection
import '../../../services/tab_repository.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  late Future<Map<String, dynamic>> _accountInfo;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  File? _imageFile; // To store the selected image
  late Future<String?> _avatarUrl; // This will store the avatar URL from the server
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _accountInfo = TabRepository().fetchAccountInfo(); // Fetch account information
    _avatarUrl = TabRepository().getAvatar(); // Fetch avatar URL
    _accountInfo.then((data) {
      _firstNameController.text = data['firstName'] ?? '';
      _lastNameController.text = data['lastName'] ?? '';
      _emailController.text = data['email'] ?? '';
    });
  }

  // Method to pick an image from the camera or gallery
  Future<void> _pickImage() async {
    // Show a dialog to choose between the camera and gallery
    final pickedFile = await showDialog<XFile>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Chọn ảnh"),
          children: [
            SimpleDialogOption(
              child: Text('Chụp ảnh'),
              onPressed: () async {
                Navigator.of(context).pop(await _picker.pickImage(source: ImageSource.camera)); // Take a photo
              },
            ),
            SimpleDialogOption(
              child: Text('Chọn từ thư viện'),
              onPressed: () async {
                Navigator.of(context).pop(await _picker.pickImage(source: ImageSource.gallery)); // Choose from gallery
              },
            ),
          ],
        );
      },
    );

    if (pickedFile != null) {
      // Convert XFile to File and send to update avatar
      File file = File(pickedFile.path); // Convert XFile to File
      await _updateAvatar(file); // Update avatar
    }
  }

  // Method to send the image file to TabRepository to update the avatar
  Future<void> _updateAvatar(File file) async {
    XFile xFile = XFile(file.path); // Convert File to XFile

    try {
      print("sdtfghjk ");
      print(_emailController.text);
      await TabRepository().updateAvatar(xFile);
      setState(() {
        _imageFile = file;  // Update the local _imageFile
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cập nhật avatar thành công")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cập nhật avatar thất bại")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Home2.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.93,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.83,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color(0xfffff8ee),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.15,
                            left: 20,
                            right: 20,
                          ),
                          child: Column(
                            children: [
                              TabBar(
                                indicatorColor: Colors.blue,
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.grey,
                                tabs: [
                                  Tab(text: "Thông tin"),
                                  Tab(text: "Đổi mật khẩu"),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    _buildInfoTab(),
                                    _buildChangePasswordTab(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Avatar with CircleShape
                        Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * 0.2,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: _imageFile == null
                              ? FutureBuilder<String?>(
                            future: _avatarUrl, // Load the avatar URL
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return SpinKitCircle(color: Colors.blue);
                              } else if (snapshot.hasError || !snapshot.hasData) {
                                return Icon(
                                  Icons.person,
                                  size: 100,
                                  color: Colors.grey,
                                );
                              } else {
                                return CircleAvatar(
                                  radius: 80,
                                  backgroundImage: NetworkImage(snapshot.data!),
                                );
                              }
                            },
                          )
                              : Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        ),
                        Positioned(
                          right: 120,
                          bottom: 0,
                          child: InkWell(
                            onTap: _pickImage, // Call the image picking method
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade400,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildInfoTab() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _accountInfo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitCircle(color: Colors.blue),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Lỗi: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Text('Không có dữ liệu'),
          );
        } else {
          return Column(
            children: [
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: "First Name"),
              ),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: "Last Name"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String firstName = _firstNameController.text;
                  String lastName = _lastNameController.text;

                  if (firstName.isEmpty || lastName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Vui lòng điền đầy đủ thông tin")),
                    );
                    return;
                  }

                  if (firstName.length > 5 || lastName.length > 5) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Tên không được quá 5 ký tự")),
                    );
                    return;
                  }

                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    final updatedInfo = await TabRepository().updateAccountInfo(
                      firstName,
                      lastName,
                      true,
                    );
                    setState(() {
                      _isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Cập nhật thông tin thành công")),
                    );

                    Navigator.pop(context, true);
                  } catch (e) {
                    setState(() {
                      _isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Lỗi khi cập nhật thông tin")),
                    );
                  }
                },
                child: Text("Cập nhật thông tin"),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildChangePasswordTab() {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: "Xác nhận email hiện tại"),
        ),
        TextField(
          obscureText: true,
          controller: _currentPasswordController,
          decoration: InputDecoration(labelText: "Mật khẩu hiện tại"),
        ),
        TextField(
          obscureText: true,
          controller: _newPasswordController,
          decoration: InputDecoration(labelText: "Mật khẩu mới"),
        ),
        TextField(
          obscureText: true,
          controller: _confirmPasswordController,
          decoration: InputDecoration(labelText: "Xác nhận mật khẩu mới"),
        ),
        if (_errorMessage.isNotEmpty)
          Text(
            _errorMessage,
            style: TextStyle(color: Colors.red),
          ),
        SizedBox(height: 20),
        _isLoading
            ? SpinKitCircle(color: Colors.blue)
            : ElevatedButton(
          onPressed: _changePassword,
          child: Text("Đổi mật khẩu"),
        ),
      ],
    );
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Mật khẩu không khớp!";
      });
      return;
    }

    if (!_isValidEmail(_emailController.text)) {
      setState(() {
        _errorMessage = "Email không hợp lệ!";
      });
      return;
    }

    if (_currentPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = "Vui lòng nhập mật khẩu hiện tại!";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await TabRepository().changePassword(
        _emailController.text,
        _currentPasswordController.text,
        _newPasswordController.text,
      );
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mật khẩu đã được thay đổi")),
      );
      Navigator.pop(context, true); // Go back and reload the page
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Lỗi khi thay đổi mật khẩu. Vui lòng thử lại.";
      });
    }
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }
}
