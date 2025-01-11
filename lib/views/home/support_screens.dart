import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Home2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Header đơn giản với tiêu đề
            Container(
              padding: const EdgeInsets.only(top: 70, bottom: 20),
              alignment: Alignment.center,
              child: const Text(
                "Hỗ Trợ",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xfffff8ee), // Màu nền sáng dễ chịu
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Align(
                              alignment: messages[index].startsWith("Bạn:")
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  color: messages[index].startsWith("Bạn:")
                                      ? Colors.grey[300]
                                      : Colors.blue[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  messages[index],
                                  style: TextStyle(
                                    color: messages[index].startsWith("Bạn:")
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Ô nhập tin nhắn và nút gửi
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: 'Nhập tin nhắn...',
                                hintStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: Colors.redAccent.withOpacity(0.4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding:
                                EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send, color: Colors.pinkAccent),
                            onPressed: () {
                              if (_controller.text.isNotEmpty) {
                                setState(() {
                                  messages.add('Bạn: ${_controller.text}');
                                  // Tự động phản hồi
                                  messages.add('Hệ thống: Tôi đã nhận được tin nhắn của bạn.');
                                });
                                _controller.clear();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
