import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'pages/homepage.dart';
import 'pages/summary.dart';
import 'pages/customizations.dart';
import 'pages/add_expense.dart'; 
import 'pages/profile.dart';
import 'pages/expense_model.dart'; // Ensure this import is here

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ExpenseHomePage(),
    );
  }
}

class ExpenseHomePage extends StatefulWidget {
  const ExpenseHomePage({super.key});

  @override
  State<ExpenseHomePage> createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  int _bottomNavIndex = 1;

  // 1. THE MASTER LIST LIVES HERE NOW
  final List<Expense> myExpenses = [];

  final iconList = <IconData>[
    Icons.bar_chart,
    Icons.home,
    Icons.settings,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    // 2. Pass the list and delete function DOWN to HomePage
    final pages = <Widget>[
      const SummaryPage(),
      HomePage(
        expenses: myExpenses,
        onDelete: (index) {
          setState(() {
            myExpenses.removeAt(index);
          });
        },
      ),
      const CustomizationPage(),
      const ProfilePage(), 
    ];

    return Scaffold(
      // Light blue/grey background from wireframe
      backgroundColor: const Color(0xFFF5F7FA), 
      body: pages[_bottomNavIndex],
      
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(), // <--- Makes the button perfectly round
        onPressed: () async {
          final newExpense = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExpensePage()),
          );

          if (newExpense != null && newExpense is Expense) {
            setState(() {
              myExpenses.add(newExpense); // Add to master list
              _bottomNavIndex = 1; // Switch to Home tab
            });
          }
        },
        backgroundColor: const Color(0xFF5E6C85), // Wireframe blue color
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