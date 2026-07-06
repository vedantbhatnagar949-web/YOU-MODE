import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'budget_screen.dart';
import 'tasks_screen.dart';
import 'study_screen.dart';
import 'journal_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const TasksScreen(),
    const BudgetScreen(),
    const StudyScreen(),
    const JournalScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.background,
          border: const Border(
            top: BorderSide(color: AppTheme.border, width: 3.0),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppTheme.background,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.onSurface,
          selectedLabelStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
          unselectedLabelStyle: Theme.of(context).textTheme.labelMedium,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.check_box_outlined),
              activeIcon: Icon(Icons.check_box),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet),
              label: 'Budget',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'Study',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              activeIcon: Icon(Icons.book),
              label: 'Journal',
            ),
          ],
        ),
      ),
    );
  }
}
