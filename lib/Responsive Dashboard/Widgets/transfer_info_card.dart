import 'package:flutter/material.dart';
import '../Config/responsive.dart';
import '../Config/size_config.dart';
import '../Utils/colors.dart';

class TransferInfoCard extends StatelessWidget {
  final String title;
  final double value;
  const TransferInfoCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: Responsive.isDesktop(context)
            ? MediaQuery.of(context).size.width / 7
            : SizeConfig.screenWidth / 2 - 40,
      ),
      padding: EdgeInsets.only(
        top: 20,
        bottom: 20,
        left: 20,
        right: Responsive.isMobile(context) ? 20 : 40,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              height: 1.3,
              color: MyAppColor.secondary,
            ),
          ),
           SizedBox(
            height: SizeConfig.blockSizeVertical * 2,
          ),
           Text(
            "$value",
            style: const TextStyle(
              fontSize: 18,
              height: 1.3,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
