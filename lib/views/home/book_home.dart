import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../controllers/books_controller.dart';
import '../../models/model_book.dart';
import '../../services/tab_repository.dart';
import '../../widgets/book_selection_widget.dart';

class BooksHome extends StatefulWidget {
  @override
  State<BooksHome> createState() => _BooksHomeState();
}

class _BooksHomeState extends State<BooksHome> {
  TextEditingController _searchController = TextEditingController();
  List<Book> allBooks = []; // Lưu trữ tất cả sách
  List<Book> filteredBooks = []; // Lưu trữ sách đã lọc
  final TabRepository _tabRepository = TabRepository(); // Khởi tạo TabRepository
  late Future<Map<String, dynamic>> _accountInfo;

  @override
  void initState() {
    super.initState();
    _loadBooks();
    _accountInfo = _tabRepository.fetchAccountInfo(); // Fetch account info here
  }

  // Tải tất cả sách
  void _loadBooks() async {
    List<Book> books = await _tabRepository.fetchBooks();
    setState(() {
      allBooks = books;
      filteredBooks = books; // Bắt đầu với tất cả sách
    });
  }

  // Tìm kiếm sách
  void _searchBooks(String query) async {
    if (query.isEmpty) {
      // Khi ô tìm kiếm rỗng, hiển thị tất cả sách
      setState(() {
        filteredBooks = allBooks;
      });
      return;
    }

    try {
      // Gọi API để tìm sách theo từ khóa
      List<Book> result = await _tabRepository.searchBooksByName(query);

      setState(() {
        filteredBooks = result.isNotEmpty ? result : []; // Cập nhật danh sách kết quả
      });
    } catch (error) {
      print('Lỗi khi tìm kiếm sách: $error');
      // Trong trường hợp lỗi, không thay đổi danh sách
      setState(() {
        filteredBooks = [];
      });
    }
  }


  // Hiển thị popup yêu cầu xác nhận trước khi mở liên kết
  void _showConfirmationDialog(bool isActive) {
    if (isActive) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Tài khoản của bạn đã được kích hoạt.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng hộp thoại
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Kích hoạt tài khoản'),
            content: Text('Tài khoản của bạn chưa được kích hoạt. Kích hoạt với giá 100 USD để sử dụng hết tính năng. Bạn có muốn tiếp tục?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng hộp thoại nếu người dùng từ chối
                },
                child: Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng hộp thoại
                  _openUrl(); // Mở liên kết nếu người dùng đồng ý
                },
                child: Text('Thanh toán'),
              ),
            ],
          );
        },
      );
    }
  }


  // Mở liên kết nếu người dùng đồng ý
  void _openUrl() async {
    try {
      http.get(Uri.parse('http://10.0.2.2:8080/pay')).then((response) {
        if (response.statusCode == 200) {
          String url = response.body;
          launch(url);
        } else {
          print('Failed to get URL: ${response.body}');
        }
      }).catchError((error) {
        print('Error fetching URL: $error');
      });
    } catch (e) {
      print('Error: $e');
    }
  }

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
            // Header with search and menu buttons
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 70, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.account_balance, color: Colors.green, size: 35),
                    onPressed: () async {
                      final accountInfo = await _accountInfo; // Lấy dữ liệu tài khoản
                      final isActive = accountInfo['active'] ?? false; // Kiểm tra trạng thái active
                      _showConfirmationDialog(isActive); // Hiển thị dialog theo trạng thái
                    },
                  ),

                  // Search bar
                  Container(
                    width: 270,
                    child: TextField(
                      controller: _searchController,
                      onChanged: _searchBooks, // Gọi _searchBooks mỗi khi người dùng nhập
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm...',
                        hintStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search, color: Colors.black),
                          onPressed: () {
                            _searchBooks(_searchController.text); // Gọi tìm kiếm khi nhấn nút tìm kiếm
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 50, left: 30),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xfffff8ee),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting Text with Full Name
                      FutureBuilder<Map<String, dynamic>>(
                        future: _accountInfo,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Loading indicator
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData || snapshot.data == null) {
                            return Text('No account info available');
                          } else {
                            final accountInfo = snapshot.data!;
                            final firstName = accountInfo['firstName'] ?? 'N/A';
                            final lastName = accountInfo['lastName'] ?? 'N/A';
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Xin Chào, ",
                                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "$firstName $lastName",
                                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 15, bottom: 30),
                                  width: 100,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: const Color(0xffc44536),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      // Book Sections
                      BookSection(
                        heading: "Đề xuất",
                        books: filteredBooks, // Truyền sách đã lọc vào
                      ),
                      BookSection(
                        heading: "Tác phẩm văn học",
                        books: filteredBooks, // Truyền sách đã lọc vào
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
