import 'package:flutter/material.dart';
import '../Utils/colors.dart';

class HeaderParts extends StatelessWidget {
  const HeaderParts({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dashboard",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  height: 1.3,
                  color: MyAppColor.primary,
                ),
              ),
              Text(
                "Payments updates",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.3,
                  color: MyAppColor.secondary,
                ),
              )
            ],
          ),
        ),
        const Spacer(flex: 1),
      ],
    );
  }
}
