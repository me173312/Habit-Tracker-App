import 'package:flutter/material.dart';
import 'package:habit_track/core/theme/color.dart';

class SettingWidget extends StatelessWidget {
  const SettingWidget(
      {super.key,
      required this.icon,
      required this.tittel,
      required this.show});
  final String tittel;
  final IconData icon;
  final bool show;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Shadow color with opacity
              spreadRadius: 2, // How much the shadow spreads
              blurRadius: 1, // The blur radius of the shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 30,
                    color: AppColor.primeColor,
                  ),
                  const SizedBox(
                      width:
                          10), // Adds some spacing between the icon and the text
                  Text(
                    tittel,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              show
                  ? Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColor.primeColor,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
