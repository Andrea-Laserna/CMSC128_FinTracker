import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/homepage.dart';
import 'pages/summary.dart';
import 'pages/customizations.dart';
import 'pages/add_expense.dart';
import 'pages/profile.dart';
import 'pages/expense_model.dart';
import 'pages/landing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final prefs = snapshot.data!;
        final bool isFirstTime = prefs.getBool("isFirstTime") ?? true;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: !isLoggedIn
              ? const LandingPage()
              : (isFirstTime ? const CustomizationPage()
                             : const ExpenseHomePage()),
        );
      },
    );
  }
}

/*
===============
  Main Screen
===============
*/
class ExpenseHomePage extends StatefulWidget {
  const ExpenseHomePage({super.key});

  @override
  State<ExpenseHomePage> createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  int _bottomNavIndex = 1;

  final iconList = <IconData>[
    Icons.bar_chart,
    Icons.home,
    Icons.settings,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const SummaryPage(),
      HomePage(key: HomePage.homePageStateKey),
      const CustomizationPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: pages[_bottomNavIndex],

      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          if (_bottomNavIndex == 1) {
            final selectedDate =
                HomePage.homePageStateKey.currentState?.getSelectedDate() ??
                    DateTime.now();

            final newExpense = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddExpensePage(initialDate: selectedDate)),
            );

            if (newExpense != null && newExpense is Expense) {
              setState(() {
                HomePage.expenses.add(newExpense);
                _bottomNavIndex = 1;
              });
            }
          } else {
            setState(() => _bottomNavIndex = 1);
          }
        },
        backgroundColor: const Color(0xFF5E6C85),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        activeColor: const Color(0xFF5E6C85),
        inactiveColor: Colors.grey,
        onTap: (index) {
          setState(() => _bottomNavIndex = index);
        },
      ),
    );
  }
}
