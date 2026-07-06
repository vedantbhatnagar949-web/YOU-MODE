import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../theme/app_theme.dart';
import '../widgets/neo_brutalist_container.dart';
import '../widgets/neo_brutalist_button.dart';
import '../models/user_profile_model.dart';
import '../models/budget_model.dart';
import 'main_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameController = TextEditingController();
  final _moneyController = TextEditingController();
  final _milestoneController = TextEditingController();
  final _classController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  Future<void> _submitForm() async {
    // Save profile
    final profile = UserProfileModel(
      name: _nameController.text,
      classGrade: _classController.text,
      age: _ageController.text,
      height: _heightController.text,
      weight: _weightController.text,
      budgetMilestone: double.tryParse(_milestoneController.text) ?? 0.0,
    );
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile', json.encode(profile.toJson()));

    // Save initial transaction
    double initialMoney = double.tryParse(_moneyController.text) ?? 0.0;
    if (initialMoney > 0) {
      final t = TransactionModel(
        id: DateTime.now().toString(),
        amount: initialMoney,
        isExpense: false,
        note: 'Initial Balance',
        timestamp: DateTime.now(),
      );
      final tJson = [json.encode(t.toJson())];
      await prefs.setStringList('budget_transactions', tJson);
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainShell()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'WELCOME TO YOU MODE',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Let\'s set up your profile.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 32),
              
              NeoBrutalistContainer(
                backgroundColor: AppTheme.secondary,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _moneyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Current Amount of Money', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _milestoneController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Budget Milestone Goal', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _classController,
                      decoration: const InputDecoration(labelText: 'Class / Grade', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _heightController,
                            decoration: const InputDecoration(labelText: 'Height', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _weightController,
                            decoration: const InputDecoration(labelText: 'Weight', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              NeoBrutalistButton(
                backgroundColor: AppTheme.primary,
                onPressed: _submitForm,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Center(
                  child: Text('INITIALIZE SYSTEM'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
