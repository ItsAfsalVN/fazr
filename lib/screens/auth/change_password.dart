import 'package:fazr/components/button.dart';
import 'package:fazr/components/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 40,
          children: [
            Column(
              children: [
                SvgPicture.asset(
                  'assets/images/logo_alt.svg',
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                ),
                Text(
                  'Change password',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                ),
              ],
            ),

            Column(
              spacing: 20,
              children: [
                InputField(
                  label: 'Current password',
                  hint: 'Enter the current password',
                ),
                InputField(
                  label: 'New password',
                  hint: 'Enter the  new password',
                ),
                InputField(
                  label: 'Confirm new password',
                  hint: 'Confirm new password',
                ),
              ],
            ),

            Button(label: 'Sign up' , onTap: (){},),
          ],
        ),
      ),
    );
  }
}
