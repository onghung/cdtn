import 'package:flutter/material.dart';
import '../../services/tab_repository.dart';
import '../Config/size_config.dart';
import '../Utils/colors.dart';

class ShowHistory extends StatefulWidget {
  const ShowHistory({super.key});

  @override
  State<ShowHistory> createState() => _ShowHistoryState();
}

class _ShowHistoryState extends State<ShowHistory> {
  final TabRepository _repository = TabRepository(); // Khởi tạo TabRepository

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _repository.fetchTransactionHistory(), // API lấy lịch sử giao dịch
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(), // Hiển thị khi đang tải
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Lỗi: ${snapshot.error}"), // Hiển thị lỗi nếu có
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("Không có dữ liệu giao dịch"), // Hiển thị nếu không có dữ liệu
          );
        }

        final transactions = snapshot.data!;

        return SingleChildScrollView(
          scrollDirection: Axis.vertical, // Chỉ hỗ trợ màn hình điện thoại
          child: SizedBox(
            width: double.infinity,
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(color: MyAppColor.secondary, width: 1),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: MyAppColor.backgroundColor,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "User Email", // Tiêu đề cột Email
                        style: const TextStyle(
                          letterSpacing: -1,
                          height: 1.3,
                          fontWeight: FontWeight.bold,
                          color: MyAppColor.secondary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Transaction Time", // Tiêu đề cột Thời gian
                        style: const TextStyle(
                          letterSpacing: -1,
                          height: 1.3,
                          fontWeight: FontWeight.bold,
                          color: MyAppColor.secondary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Amount (USD)", // Tiêu đề cột Số tiền
                        style: const TextStyle(
                          letterSpacing: -1,
                          height: 1.3,
                          fontWeight: FontWeight.bold,
                          color: MyAppColor.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                // Hiển thị các giao dịch trong dữ liệu
                ...transactions.map((transaction) {
                  return TableRow(
                    decoration: const BoxDecoration(
                      color: MyAppColor.backgroundColor,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          transaction['email'] ?? 'N/A',
                          style: const TextStyle(
                            letterSpacing: -1,
                            height: 1.3,
                            color: MyAppColor.secondary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          transaction['transactionTime'] ?? 'Unknown',
                          style: const TextStyle(
                            letterSpacing: -1,
                            height: 1.3,
                            color: MyAppColor.secondary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            "100", // Null check for amount
                            style: const TextStyle(
                              letterSpacing: -1,
                              height: 1.3,
                              color: MyAppColor.secondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
