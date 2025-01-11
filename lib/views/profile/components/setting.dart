import 'package:flutter/material.dart';

class setting extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<setting> {
  bool notificationsEnabled = true;
  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài Đặt'),
        backgroundColor: isDarkTheme ? Color(0xff1a1a2e) : Color(0xfffff8ee),
        foregroundColor: isDarkTheme ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text('Tắt thông báo', style: TextStyle(fontSize: 18)),
              value: notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
          ],
        ),
      ),
      backgroundColor: isDarkTheme ? Color(0xff1a1a2e) : Color(0xfffff8ee),
    );
  }
}