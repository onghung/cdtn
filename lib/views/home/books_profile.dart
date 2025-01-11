import 'dart:io'; // To use File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker package
import 'package:tlubook/views/profile/components/myacount.dart';
import 'package:tlubook/views/profile/components/notify.dart';
import 'package:tlubook/views/profile/components/setting.dart';
import 'package:tlubook/views/profile/components/supportCenter.dart';
import '../../TaiKhoan/screens/login.dart';
import '../../services/tab_repository.dart'; // Import TabRepository
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../profile/profile_menu.dart'; // To show the spinner while loading

class BooksProfile extends StatefulWidget {
  @override
  _BooksProfileState createState() => _BooksProfileState();
}

class _BooksProfileState extends State<BooksProfile> {
  late Future<Map<String, dynamic>> _accountInfo;
  late Future<String?> _avatarUrl;
  final ImagePicker _picker = ImagePicker(); // Initialize ImagePicker

  @override
  void initState() {
    super.initState();
    _accountInfo = TabRepository().fetchAccountInfo(); // Fetch account information
    _avatarUrl = TabRepository().getAvatar(); // Fetch avatar URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Home2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.87,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.765,
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
                      top: MediaQuery.of(context).size.height * 0.1,
                      left: 20,
                      right: 20,
                    ),
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: _accountInfo,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: SpinKitCircle(color: Colors.blue),
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return Center(child: Text('No data available'));
                        } else {
                          final accountInfo = snapshot.data!;
                          final firstName = accountInfo['firstName'] ?? 'N/A';
                          final lastName = accountInfo['lastName'] ?? 'N/A';
                          final activeStatus = accountInfo['active']
                              ? 'Đã kích hoạt'
                              : 'Chưa kích hoạt';
                          return Column(
                            children: [
                              Text(
                                "$firstName $lastName",
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Column(
                                children: [
                                  const SizedBox(height: 20),
                                  ProfileMenu(
                                    text: "Tài khoản của tôi",
                                    icon: "assets/icons/User Icon.svg",
                                    press: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MyAccount(),
                                        ),
                                      );
                                      if (result == true) {
                                        setState(() {
                                          _accountInfo = TabRepository().fetchAccountInfo();
                                        });
                                      }
                                    },
                                  ),

                                  ProfileMenu(
                                    text: "Trung tâm hỗ trợ",
                                    icon: "assets/icons/Question mark.svg",
                                    press: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => supportCenter(),
                                      ),
                                    ),
                                  ),
                                  ProfileMenu(
                                      text: "Đăng xuất",
                                      icon: "assets/icons/Log out.svg",
                                      press: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LogInScreen(),
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              // Stack for Avatar and Camera Icon
              Positioned(
                left: MediaQuery.of(context).size.width/3,
                child: Stack(
                  children: [
                    // Display Avatar
                    FutureBuilder<String?>(
                      future: _avatarUrl,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, size: 60, color: Colors.white),
                          );
                        } else if (snapshot.hasError) {
                          return CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, size: 60, color: Colors.white),
                          );
                        } else if (snapshot.hasData && snapshot.data != null) {
                          return CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(snapshot.data!),
                          );
                        } else {
                          return CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, size: 60, color: Colors.white),
                          );
                        }
                      },
                    ),
                    // Camera Icon at Bottom Right
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final kTitleStyle = TextStyle(
  fontSize: 20,
  color: Colors.grey,
  fontWeight: FontWeight.w700,
);

final kSubtitleStyle = TextStyle(
  fontSize: 26,
  color: Colors.black,
  fontWeight: FontWeight.w700,
);
