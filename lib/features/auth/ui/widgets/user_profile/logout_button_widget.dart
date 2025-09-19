import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class LogoutButtonWidget extends StatelessWidget {
  const LogoutButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        minimumSize: Size(double.infinity, 45),
      ),
      onPressed: () {},
      child: Text("Logout", style: TextStyle(color: Colors.black)),
    );
  }
}
