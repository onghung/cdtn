import 'package:flutter/material.dart';

import '../../Responsive Dashboard/dashboard.dart';

class BookSetUp extends StatefulWidget {
  const BookSetUp({super.key});

  @override
  State<BookSetUp> createState() => _BookSetUpState();
}

class _BookSetUpState extends State<BookSetUp> {
  @override
  Widget build(BuildContext context) {
    return MyDashboard();
  }
}
