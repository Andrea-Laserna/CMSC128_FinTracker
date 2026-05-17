import '../expense_model.dart';
import 'category_summary.dart';

class SummaryData {
  final double total;
  final double previousTotal;
  final List<CategorySummary> categories;
  final List<CategorySummary> chartCategories;
  final List<Expense> periodExpenses;
  final DateTime start;
  final DateTime end;

  const SummaryData({
    required this.total,
    required this.previousTotal,
    required this.categories,
    required this.chartCategories,
    required this.periodExpenses,
    required this.start,
    required this.end,
  });
}
