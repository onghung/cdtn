import 'package:av_smooth_star_rating/av_smooth_star_rating.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/model_book.dart';
import '../../services/tab_repository.dart';
import 'book_read.dart';
import 'package:http/http.dart' as http;
import 'books_listen.dart';

class BooksDetails extends StatefulWidget {
  final Book book;
  BooksDetails({required this.book});

  @override
  State<BooksDetails> createState() => _BooksDetailsState();
}

class _BooksDetailsState extends State<BooksDetails> {
  bool isFavorite = false; // Trạng thái yêu thích
  bool isActive = true;

  Future<void> fetchActiveStatus() async {
    try {
      final activeStatus = await repository.fetchAccountInfo();
      setState(() {
        isActive = activeStatus["active"]; // Cập nhật trạng thái từ server
      });
    } catch (e) {
      print("Lỗi khi lấy trạng thái active: ${e.toString()}");
      setState(() {
        isActive = false; // Nếu có lỗi, đặt trạng thái là không active
      });
    }
  }

  final TabRepository repository = TabRepository(); // Khởi tạo repository

  // Phương thức để lấy trạng thái yêu thích từ server
  Future<void> fetchFavoriteStatus() async {
    try {
      final isFavorite = await repository.checkFavoriteStatus(widget.book.id);
      setState(() {
        this.isFavorite = isFavorite; // Cập nhật trạng thái từ server
      });
    } catch (e) {

    }
  }

  // Hiển thị popup yêu cầu xác nhận trước khi mở liên kết
  void _showConfirmationDialog() {
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
                Navigator.of(context).pop();
              },
              child: Text('Thanh toán'),
            ),
          ],
        );
      },
    );
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


  // Phương thức để chuyển đổi trạng thái yêu thích
  Future<void> toggleFavorite() async {
    try {
      final response = await repository.toggleFavoriteBook(widget.book.id);
      setState(() {
        isFavorite = response["isFavorite"]; // Cập nhật trạng thái mới từ server
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["message"])),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: ${e.toString()}")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFavoriteStatus(); // Lấy trạng thái yêu thích từ server
    fetchActiveStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffff8ee),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            SafeArea(
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 35,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.black,
                              size: 35,
                            ),
                            onPressed: toggleFavorite, // Gọi hàm toggleFavorite
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 30,
                      ),
                      height: MediaQuery.of(context).size.height * 0.32,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 25,
                                  offset: Offset(8, 8),
                                  spreadRadius: 3,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 25,
                                  offset: Offset(-8, -8),
                                  spreadRadius: 3,
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                widget.book.url,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: new LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.3),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      widget.book.name,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "By ${widget.book.name}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SmoothStarRating(
                          rating: widget.book.start,
                          isReadOnly: false,
                          size: 25,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          defaultIconData: Icons.star_border,
                          starCount: 5,
                          allowHalfRating: true,
                          spacing: 2.0,
                          onRated: (value) {
                            print(value);
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${widget.book.start}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(24),
                      height: 8,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 40,
                            right: 20,
                          ),
                          child: Text(widget.book.content,
                            style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 1.5,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [
                      Color(0xfffff8ee).withOpacity(0.1),
                      Colors.white.withOpacity(0.3),
                      Color(0xfffff8ee).withOpacity(0.7),
                      Color(0xfffff8ee).withOpacity(0.8),
                      Color(0xfffff8ee),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 150,
                        height: 60,
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BooksRead(book: widget.book),
                            ),
                          ),
                          child: Text(
                            "ĐỌC",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 150,
                        height: 60,
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        child: ElevatedButton(
                          onPressed: isActive
                              ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BooksListen(
                                book: widget.book,
                              ),
                            ),
                          )
                              : _showConfirmationDialog, // Nếu không active, nút sẽ bị vô hiệu hóa
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isActive ? Colors.blue : Colors.grey, // Đổi màu nút
                          ),
                          child: Text(
                            "NGHE",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                            ),
                          ),
                        ),
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
