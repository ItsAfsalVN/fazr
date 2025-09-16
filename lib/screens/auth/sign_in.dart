import 'package:fazr/components/button.dart';
import 'package:fazr/components/input_field.dart';
import 'package:fazr/screens/auth/change_password.dart';
import 'package:fazr/screens/auth/sign_up.dart';
import 'package:fazr/screens/tabs/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

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
                  'Welcome back to Fazr',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                ),
              ],
            ),

            Column(
              spacing: 20,
              children: [
                InputField(label: 'Email', hint: 'Enter your email'),
                InputField(label: 'Password', hint: 'Enter the password'),

                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePassword()),
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot password ?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Column(
              spacing: 10,
              children: [
                Button(
                  label: 'Sign in',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 6,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
