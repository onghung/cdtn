import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tlubook/models/model_book.dart';

import '../../services/tab_repository.dart'; // Assuming this is where Book is defined

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? description;
  String? content;
  int? price;
  double? rating;
  String? sound;
  String? url;
  String? view;

  final ImagePicker _imagePicker = ImagePicker();
  final TabRepository _tabRepository = TabRepository();

  // Chọn tệp âm thanh
  Future<void> _pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );

      if (result != null) {
        String? filePath = result.files.single.path;
        print("Đã chọn file âm thanh: $filePath");
        setState(() {
          sound = filePath;
        });
      } else {
        print("Không có file nào được chọn.");
      }
    } catch (e) {
      print("Lỗi khi chọn file: $e");
    }
  }

  // Chọn tệp hình ảnh
  Future<void> _pickImageFile() async {
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        url = image.path;
      });
    }
  }

  // Thêm sách
  Future<void> _addBook() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Kiểm tra nếu chưa chọn cả ảnh và âm thanh
      if (url == null || sound == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cả ảnh và âm thanh đều là bắt buộc!")),
        );
        return; // Dừng lại nếu chưa chọn cả hai tệp
      }

      // Kiểm tra nếu rating và price không hợp lệ
      if (price == null || price! <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Giá phải là một số hợp lệ")),
        );
        return;
      }

      if (rating == null || rating! < 0 || rating! > 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đánh giá phải nằm trong khoảng từ 0 đến 5")),
        );
        return;
      }

      try {
        Book newBook = Book(
          id: '02', // ID is typically assigned by the backend
          view: view ?? '0',
          price: price ?? 0,
          description: description!,
          content: content!,
          url: url ?? '', // Đảm bảo đã chọn ảnh
          name: name!,
          start: rating ?? 0.0,
          sound: sound ?? '', // Đảm bảo đã chọn âm thanh
        );

        // Gọi API thêm sách
        await _tabRepository.addBook(newBook);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Thêm sách thành công!")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm mới sách"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Tên sách"),
                validator: (value) =>
                value!.isEmpty ? "Tên sách không được để trống" : null,
                onSaved: (value) => name = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: "Mô tả"),
                validator: (value) =>
                value!.isEmpty ? "Mô tả không được để trống" : null,
                onSaved: (value) => description = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: "Nội dung"),
                maxLines: 4,
                validator: (value) =>
                value!.isEmpty ? "Nội dung không được để trống" : null,
                onSaved: (value) => content = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: "Giá"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? "Giá không được để trống" : null,
                onSaved: (value) => price = int.tryParse(value!),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: "Đánh giá"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSaved: (value) => rating = double.tryParse(value ?? '0'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickAudioFile,
                child: Text(sound ?? "Chọn file âm thanh"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImageFile,
                child: Text(url ?? "Chọn ảnh"),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _addBook,
                child: Text("Thêm mới"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
