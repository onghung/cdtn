import 'package:flutter/material.dart';
import '../services/tab_repository.dart';
import 'Config/responsive.dart';
import 'Config/size_config.dart';
import 'Model/model.dart';
import 'Utils/colors.dart';
import 'Widgets/bar_chart.dart';
import 'Widgets/header_action_items.dart';
import 'Widgets/header_parts.dart';
import 'Widgets/payment_detail_info.dart';
import 'Widgets/show_history.dart';
import 'Widgets/side_drawer_menu.dart';
import 'Widgets/transfer_info_card.dart';

class MyDashboard extends StatelessWidget {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  MyDashboard({super.key});

  Future<Map<String, int>> fetchActiveUsersCount() async {
    return await TabRepository().fetchActiveUsersCount();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                flex: 1,
                child: SideDrawerMenu(),
              ),
            Expanded(
              flex: 10,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding:
                  const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeaderParts(),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 4,
                      ),
                      FutureBuilder<Map<String, int>>(
                        future: fetchActiveUsersCount(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Lỗi khi tải dữ liệu');
                          } else if (snapshot.hasData) {
                            // Lấy dữ liệu activeUsersCount từ API
                            int activeUsersCount = snapshot.data?['activeUsersCount'] ?? 0;
                            int totalUsersCount = snapshot.data?['totalUsersCount'] ?? 0;

                            return SizedBox(
                              width: SizeConfig.screenWidth,
                              child: Wrap(
                                spacing: 20,
                                runSpacing: 20,
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  TransferInfoCard(
                                    title: 'Doanh số(USD)',
                                    value: (activeUsersCount * 100).toDouble(), // Keep value as double
                                  ),
                                  TransferInfoCard(
                                    title: 'Người dùng',
                                    value: totalUsersCount.toDouble(), // Keep value as double
                                  ),
                                  TransferInfoCard(
                                    title: 'Người kích hoạt',
                                    value: activeUsersCount.toDouble(), // Keep value as double
                                  ),
                                  TransferInfoCard(
                                    title: 'Tỉ lệ kích hoạt %',
                                    value: (activeUsersCount / totalUsersCount).toDouble()*100, // Keep value as double
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Text('Không có dữ liệu');
                          }
                        },
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 4,
                      ),
                      // const Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           "Doanh thu",
                      //           style: TextStyle(
                      //             fontSize: 16,
                      //             color: MyAppColor.secondary,
                      //             height: 1.3,
                      //           ),
                      //         ),
                      //         Text(
                      //           '6.000.000',
                      //           style: TextStyle(
                      //             fontSize: 30,
                      //             color: MyAppColor.primary,
                      //             fontWeight: FontWeight.w800,
                      //             height: 1.3,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     Text(
                      //       '30 Ngày qua',
                      //       style: TextStyle(
                      //         fontSize: 16,
                      //         color: MyAppColor.secondary,
                      //         height: 1.3,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: SizeConfig.blockSizeVertical * 3,
                      // ),
                      // const SizedBox(
                      //   height: 180,
                      //   child: BarChartRepresentation(),
                      // ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 5,
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lịch sử giao dịch',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: MyAppColor.primary,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),
                      const ShowHistory(),
                    ],
                  ),
                ),
              ),
            ),
            if (Responsive.isDesktop(context))
              Expanded(
                flex: 4,
                child: SafeArea(
                  child: Container(
                    width: double.infinity,
                    height: SizeConfig.screenHeight,
                    decoration:
                    const BoxDecoration(color: MyAppColor.secondaryBg),
                    child: const SingleChildScrollView(
                      padding:
                      EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      child: Column(
                        children: [HeaderActionItems(), PaymentDetailInfo()],
                      ),
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
