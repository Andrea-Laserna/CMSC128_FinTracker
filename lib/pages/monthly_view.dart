import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../database/db_helper.dart';
import 'expense_model.dart';

class MonthlyViewPage extends StatefulWidget {
  const MonthlyViewPage({super.key});

  @override
  State<MonthlyViewPage> createState() => _MonthlyViewPageState();
}

class _MonthlyViewPageState extends State<MonthlyViewPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Expense> _allExpenses = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadAllExpenses();
  }

  // Fetch data from your database
  Future<void> _loadAllExpenses() async {
    final data = await DBHelper().getAllExpenses();
    setState(() {
      _allExpenses = data;
    });
  }

  // DOt markers to show that there expenses on the given day
  List<Expense> _getExpensesForDay(DateTime day) {
    return _allExpenses.where((expense) {
      return expense.date.year == day.year &&
             expense.date.month == day.month &&
             expense.date.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black), 
        title: const Text(
          'Monthly View',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TableCalendar<Expense>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getExpensesForDay, 
              
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Color(0xFF5E6C85), 
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Color(0xFFDCE8F5),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(color: Colors.black),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false, 
                titleCentered: true,
              ),

              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay; 
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: Center(
              child: Text(
                'Your total expenses for ${_selectedDay?.month}/${_selectedDay?.day} will go here.',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}