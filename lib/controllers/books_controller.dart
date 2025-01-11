import '../models/model_book.dart';
import '../services/tab_repository.dart';

class Controller {
  final TabRepository _repository = TabRepository();

  Future<List<Book>> fetchBooks() async {
    return await _repository.fetchBooks();
  }
}
