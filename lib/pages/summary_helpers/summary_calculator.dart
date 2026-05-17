import '../expense_model.dart';
import 'category_style.dart';
import 'category_summary.dart';
import 'summary_data.dart';
import 'summary_date_utils.dart';

class SummaryCalculator {
  static List<Expense> expensesInRange(
    List<Expense> expenses,
    DateTime start,
    DateTime end,
  ) {
    final cleanStart = SummaryDateUtils.cleanDate(start);
    final cleanEnd = SummaryDateUtils.cleanDate(end);

    return expenses.where((expense) {
      final expenseDate = SummaryDateUtils.cleanDate(expense.date);
      return !expenseDate.isBefore(cleanStart) &&
          !expenseDate.isAfter(cleanEnd);
    }).toList();
  }

  static double totalForRange(
    List<Expense> expenses,
    DateTime start,
    DateTime end,
  ) {
    return expensesInRange(expenses, start, end)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  static SummaryData calculate({
    required List<Expense> expenses,
    required DateTime start,
    required DateTime end,
    required DateTime previousStart,
    required DateTime previousEnd,
  }) {
    final periodExpenses = expensesInRange(expenses, start, end);
    final total = periodExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
    final previousTotal = totalForRange(expenses, previousStart, previousEnd);

    final Map<String, double> categoryTotals = {};
    for (final expense in periodExpenses) {
      categoryTotals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    final categories = categoryTotals.entries.map((entry) {
      return CategorySummary(
        name: entry.key,
        amount: entry.value,
        color: CategoryStyle.getColor(entry.key),
      );
    }).toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    final chartCategories = categories
        .where((category) => category.amount > 0)
        .toList();

    return SummaryData(
      total: total,
      previousTotal: previousTotal,
      categories: categories,
      chartCategories: chartCategories,
      periodExpenses: periodExpenses,
      start: start,
      end: end,
    );
  }

  static int transactionCountForCategory({
    required List<Expense> expenses,
    required String category,
    required DateTime start,
    required DateTime end,
  }) {
    return expensesInRange(expenses, start, end).where((expense) {
      return expense.category.toLowerCase() == category.toLowerCase();
    }).length;
  }
}
