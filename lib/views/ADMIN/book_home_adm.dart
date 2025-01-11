import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../controllers/books_controller.dart';
import '../../models/model_book.dart';
import '../../services/tab_repository.dart';
import '../../widgets/book_selection_widget.dart';
import 'BookSectionADM.dart';

class BooksHomeADM extends StatefulWidget {
  @override
  State<BooksHomeADM> createState() => _BooksHomeState();
}

class _BooksHomeState extends State<BooksHomeADM> {
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.8,
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
                      BookSectionADM(
                        heading: "Đề xuất",
                        books: filteredBooks, // Truyền sách đã lọc vào
                      ),
                      BookSectionADM(
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
