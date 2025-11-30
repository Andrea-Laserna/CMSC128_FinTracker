import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'pages/homepage.dart';
import 'pages/summary.dart';
import 'pages/customizations.dart';
import 'pages/add_expense.dart'; 
import 'pages/profile.dart';
import 'pages/expense_model.dart';

/*
===============
  ENTRY POINT
===============
*/ 
void main() {
  runApp(const MyApp());
}

// Define the root widget, set the application theme, and entry screen (ExpenseHomePage)
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

/*
===============
  Main Screen
===============
*/ 

// Stateful because it needs to track which tab is currently selected
class ExpenseHomePage extends StatefulWidget {
  const ExpenseHomePage({super.key});

  @override
  State<ExpenseHomePage> createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  // Track selected tab: 1 means Home Tab is selected first
  int _bottomNavIndex = 1;

  final iconList = <IconData>[
    Icons.bar_chart,
    Icons.home,
    Icons.settings,
    Icons.person, // dummy
  ];

  @override
  Widget build(BuildContext context) {
    // List of all the screens
    final pages = <Widget>[
      const SummaryPage(),
      HomePage(key: HomePage.homePageStateKey),
      const CustomizationPage(),
      const ProfilePage(), // dummy
    ];

    return Scaffold(
      body: pages[_bottomNavIndex],
      // Code for the add button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Check if we are in Home Page
          if (_bottomNavIndex == 1) {
            // Get the currently selected date from the HomePage State
            final selectedDate = HomePage.homePageStateKey.currentState?.getSelectedDate() ?? DateTime.now();
            
            final newExpense = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddExpensePage(initialDate: selectedDate)),
            );

            if (newExpense != null) {
              setState(() {
                HomePage.expenses.add(newExpense); // rebuild HomePage
                _bottomNavIndex = 1; // switch to Home tab
              });
            }
          } else {
            /* If user presses the floating action btn while on another tab,
              Default to Home Page
            */
            setState(() => _bottomNavIndex = 1);
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        // Update the state (selected index) when tapping a tab
        onTap: (index) {
          setState(() => _bottomNavIndex = index);
        },
      ),
    );
  }
}
