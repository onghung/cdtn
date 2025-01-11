import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class supportCenter extends StatelessWidget {
  final String supportNumber = '0394530890';

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color(0xfffff8ee),
      appBar: AppBar(
        title: Text('Trung Tâm Hỗ Trợ'),
        backgroundColor: Color(0xfffff8ee),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Xin chào! Đây là trung tâm hỗ trợ của chúng tôi. Nếu bạn cần giúp đỡ, hãy liên hệ với chúng tôi ngay.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Số điện thoại hỗ trợ: $supportNumber',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Các câu hỏi thường gặp:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '1. Làm thế nào để tải sách nói?\nBạn có thể tải sách nói bằng cách vào mục Thư viện, chọn sách yêu thích và nhấn nút Tải Về.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '2. Làm sao để tạo tài khoản?\nBạn có thể tạo tài khoản bằng cách nhấn nút Đăng ký trên màn hình chính và điền các thông tin cần thiết.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '3. Tôi quên mật khẩu, phải làm sao?\nHãy nhấn vào nút Quên mật khẩu và làm theo hướng dẫn để khôi phục tài khoản của bạn.',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _makePhoneCall(supportNumber),
                icon: Icon(Icons.phone),
                label: Text('Gọi Hỗ Trợ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffc44536),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

