import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../theme/app_theme.dart';
import 'main_shell.dart';
import 'onboarding_screen.dart';
import '../models/user_profile_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? _userName;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _checkFirstBoot();
  }

  Future<void> _checkFirstBoot() async {
    final prefs = await SharedPreferences.getInstance();
    final userProfileJson = prefs.getString('user_profile');

    if (userProfileJson != null && userProfileJson.isNotEmpty) {
      final profile = UserProfileModel.fromJson(json.decode(userProfileJson));
      if (mounted) {
        setState(() {
          _userName = profile.name;
        });
      }
      
      // Wait a moment then trigger fade in
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }

      // Wait for 2 seconds to show the greeting
      await Future.delayed(const Duration(seconds: 2));
      
      // Trigger fade out
      if (mounted) {
        setState(() {
          _opacity = 0.0;
        });
      }

      // Wait for fade out animation to finish
      await Future.delayed(const Duration(milliseconds: 1000));
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainShell()),
        );
      }
    } else {
      // First boot, wait 1 second for standard splash, then go to onboarding
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'YOU MODE',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    letterSpacing: 4.0,
                  ),
            ),
            if (_userName != null) ...[
              const SizedBox(height: 24),
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 1000),
                child: Text(
                  'HELLO ${_userName!.toUpperCase()}\nWELCOME TO YOUMODE',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.primary,
                        height: 1.5,
                      ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              color: AppTheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
