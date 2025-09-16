import 'package:fazr/components/button.dart';
import 'package:fazr/components/input_field.dart';
import 'package:fazr/screens/auth/sign_in.dart';
import 'package:fazr/screens/tabs/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

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
                  'Sign up to Fazr',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                ),
              ],
            ),

            Column(
              spacing: 20,
              children: [
                InputField(label: 'Email', hint: 'Enter your email'),
                InputField(label: 'Full name', hint: 'Enter your full name'),
                InputField(label: 'Password', hint: 'Enter the password'),
                InputField(
                  label: 'Confirm password',
                  hint: 'Confirm your password',
                ),
              ],
            ),

            Column(
              spacing: 10,
              children: [
                Button(
                  label: 'Sign up',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignIn()),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 6,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Sign In',
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
