import 'package:fazr/components/button.dart';
import 'package:fazr/components/input_field.dart';
import 'package:fazr/models/user_model.dart';
import 'package:fazr/providers/user_provider.dart';
import 'package:fazr/screens/auth/sign_in.dart';
import 'package:fazr/screens/tabs/dashboard.dart';
import 'package:fazr/services/authentication_service.dart';
import 'package:fazr/services/database_services.dart';
import 'package:fazr/utils/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isLoading = false;

  void _handleSignUp() async {
    // --- FIX 1: More complete validation ---
    if (_fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      showSnackBar(context, SnackBarType.error, "Please fill in all fields.");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      showSnackBar(context, SnackBarType.error, "Passwords do not match.");
      return;
    }

    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    try {
      User? user = await signUpWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (user != null) {
        UserModel userModel = UserModel(
          id: user.uid,
          fullname: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
        );

        await createUserInFireStore(userModel);

        if (!mounted) return;

        Provider.of<UserProvider>(context, listen: false).setUser(userModel);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      // --- FIX 4: Better error handling for user feedback ---
      if (mounted) {
        showSnackBar(
          context,
          SnackBarType.error,
          e.message ?? "An error occurred.",
        );
      }
    } catch (error) {
      if (mounted) {
        showSnackBar(context, SnackBarType.error, "An unknown error occurred.");
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- FIX 2: Removed resizeToAvoidBottomInset: false ---
      body: SingleChildScrollView(
        // --- FIX 2: Added SingleChildScrollView ---
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/logo_alt.svg',
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                  const Text(
                    'Sign up to Fazr',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  InputField(
                    label: 'Email',
                    hint: 'Enter your email',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    label: 'Full name',
                    hint: 'Enter your full name',
                    controller: _fullNameController,
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    label: 'Password',
                    hint: 'Enter the password',
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    label: 'Confirm password',
                    hint: 'Confirm your password',
                    controller: _confirmPasswordController,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  Button(
                    label: 'Sign up',
                    onTap: _handleSignUp,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    // --- FIX 3: Navigation bug fixed ---
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignIn()),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Already have an account?',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 6),
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
      ),
    );
  }
}
