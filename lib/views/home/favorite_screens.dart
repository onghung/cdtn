import 'package:flutter/material.dart';
import '../../models/model_book.dart';
import '../../services/tab_repository.dart';
import '../../widgets/book_selection_widget.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final TabRepository _tabRepository = TabRepository();
  List<Book> _favoriteBooks = [];
  List<Book> _filteredBooks = [];

  // Hàm để lấy danh sách sách yêu thích
  Future<List<Book>> _loadFavoriteBooks() async {
    try {
      List<Book> favoriteBooks = await _tabRepository.fetchFavoriteBooks();
      return favoriteBooks;
    } catch (e) {
      print('Error loading favorite books: $e');
      throw e; // Re-throw the error to handle it in the snapshot's error state
    }
  }

  // Tìm kiếm sách yêu thích
  void _searchBooks(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredBooks = _favoriteBooks; // If search query is empty, show all books
      });
    } else {
      // Filter the books based on the search query
      setState(() {
        _filteredBooks = _favoriteBooks
            .where((book) => book.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
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
              padding: const EdgeInsets.only(top: 70, bottom: 20),
              alignment: Alignment.center,
              child: const Text(
                "Yêu thích",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
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
                      // Use FutureBuilder to load books
                      FutureBuilder<List<Book>>(
                        future: _loadFavoriteBooks(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No favorite books found.'));
                          } else {
                            _favoriteBooks = snapshot.data!;
                            _filteredBooks = _favoriteBooks; // Initialize filteredBooks
                            return BookSection(
                              heading: "Danh sách yêu thích",
                              books: _filteredBooks, // Pass the filtered books here
                            );
                          }
                        },
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
