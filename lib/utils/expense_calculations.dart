import '../pages/expense_model.dart';
import 'date_utils.dart';

bool _isCashIn(Expense e) => e.category == 'CASH IN';

double calculateMonthlyCashIn(List<Expense> expenses, DateTime month) {
  return expenses
      .where((e) => e.date.month == month.month && 
                    e.date.year == month.year && 
                    e.category == 'CASH IN')
      .fold(0.0, (sum, e) => sum + e.amount);
}

double calculateWeeklySpent(List<Expense> expenses, List<DateTime> weekDates) {
  double total = 0.0;
  for (var expense in expenses) {
    if (weekDates.any((d) => isSameDay(d, expense.date)) && !_isCashIn(expense)) {
      total += expense.amount;
    }
  }
  return total;
}

String getWeeklyTotal(List<Expense> expenses, List<DateTime> weekDates) {
  return '₱${calculateWeeklySpent(expenses, weekDates).toStringAsFixed(2)}';
}

String getDayTotal(List<Expense> expenses, DateTime date) {
  final dayExpenses = expenses.where((e) => isSameDay(e.date, date) && !_isCashIn(e)).toList();
  final total = dayExpenses.fold(0.0, (sum, e) => sum + e.amount);
  return '₱${total.toStringAsFixed(2)}';
}

String getBalanceLeft(List<Expense> expenses, List<DateTime> weekDates, double budget) {
  final totalCashIn = expenses.where((e) => weekDates.any((d) => isSameDay(d, e.date)) && _isCashIn(e)).fold(0.0, (sum, e) => sum + e.amount);
  final balance = budget + totalCashIn - calculateWeeklySpent(expenses, weekDates);
  return '₱${balance.toStringAsFixed(2)}';
}

String getSavings(List<Expense> expenses, List<DateTime> weekDates, double budget) {
  final totalCashIn = expenses.where((e) => weekDates.any((d) => isSameDay(d, e.date)) && _isCashIn(e)).fold(0.0, (sum, e) => sum + e.amount);
  double savings = budget + totalCashIn - calculateWeeklySpent(expenses, weekDates);
  if (savings < 0) savings = 0;
  return '₱${savings.toStringAsFixed(2)}';
}