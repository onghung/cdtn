import 'package:flutter/material.dart';

import '../../controllers/books_controller.dart';
import '../../models/model_book.dart';


class MyView extends StatelessWidget {
  final Controller _controller = Controller();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dio Example'),
        ),
        body: FutureBuilder<List<Book>>(
          future: _controller.fetchBooks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Book book = snapshot.data![index];
                  return ListTile(
                    title: Text("á"),
                    subtitle: Text(book.description),
                    leading: Image.network(book.url),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
