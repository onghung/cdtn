import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

//Thay đổi định dạng ngày tháng
String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

//kiểm tra kết nối mạng
Future<bool> checkInternetConnection() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

//mã hóa mật khẩu
String encryptPassword(String password) {
  var bytes = utf8.encode(password); // encode UTF-8
  var digest = sha256.convert(bytes);
  return digest.toString();
}

//hộp thoại cảnh báo
void showAlertDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}