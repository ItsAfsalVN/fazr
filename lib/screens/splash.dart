import 'dart:async';
import 'package:fazr/models/user_model.dart';
import 'package:fazr/providers/user_provider.dart';
import 'package:fazr/screens/auth/sign_in.dart';
import 'package:fazr/screens/tabs/dashboard.dart';
import 'package:fazr/services/database_services.dart';
import 'package:fazr/services/storage_service.dart'; // Import storage service
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _scaleAnimation = Tween<double>(
      begin: .5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    _navigateUser();
  }

  Future<void> _navigateUser() async {
    var results = await Future.wait([
      Future.delayed(const Duration(seconds: 3)),
      FirebaseAuth.instance.authStateChanges().first,
    ]);

    if (!mounted) return;

    final firebaseUser = results[1] as User?;

    if (firebaseUser != null) {
      UserModel? userModel = await getUserFromFireStore(firebaseUser.uid);

      if (userModel != null && mounted) {
        final String? githubAvatarUrl = await getAvatarUrlFromGitHub(
          firebaseUser.uid,
        );
        final updatedUserModel = userModel.copyWith(avatar: githubAvatarUrl);

        Provider.of<UserProvider>(
          context,
          listen: false,
        ).setUser(updatedUserModel);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 150,
                  height: 150,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
