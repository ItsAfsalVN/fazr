// lib/screens/auth/sign_in.dart

import 'package:fazr/components/button.dart';
import 'package:fazr/components/input_field.dart';
import 'package:fazr/models/user_model.dart';
import 'package:fazr/providers/user_provider.dart';
import 'package:fazr/screens/auth/change_password.dart';
import 'package:fazr/screens/auth/sign_up.dart';
import 'package:fazr/screens/tabs/dashboard.dart';
import 'package:fazr/services/authentication_service.dart';
import 'package:fazr/services/database_services.dart';
import 'package:fazr/services/storage_service.dart'; // Import storage service
import 'package:fazr/utils/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showSnackBar(context, SnackBarType.error, "Please fill in all fields.");
      return;
    }

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      User? user = await signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (user != null && mounted) {
        UserModel? userModel = await getUserFromFireStore(user.uid);

        if (userModel != null) {
          // --- ADDED: Fetch latest avatar from GitHub ---
          final String? githubAvatarUrl = await getAvatarUrlFromGitHub(
            user.uid,
          );
          final updatedUserModel = userModel.copyWith(avatar: githubAvatarUrl);

          context.read<UserProvider>().setUser(updatedUserModel);
          // --- END OF CHANGE ---

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()),
            (route) => false,
          );
        } else {
          throw Exception("User data not found. Please contact support.");
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          SnackBarType.error,
          e.message ?? "An error occurred.",
        );
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, SnackBarType.error, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 80,
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
                      'Welcome back to Fazr',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
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
                      label: 'Password',
                      hint: 'Enter the password',
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePassword(),
                        ),
                      ),
                      child: const Align(
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
                const SizedBox(height: 40),
                Column(
                  children: [
                    Button(
                      label: 'Sign in',
                      onTap: _handleSignIn,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: 6),
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
        ),
      ),
    );
  }
}
