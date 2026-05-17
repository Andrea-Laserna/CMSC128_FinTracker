import 'package:shared_preferences/shared_preferences.dart';
import 'summary_enums.dart';

class SummaryBudgetService {
  static Future<double> getConvertedBudget({
    required SummaryMode summaryMode,
    required DateTime start,
    required DateTime end,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final savedBudget = prefs.getDouble('budgetAmount') ?? 0.0;
    final savedCycle = prefs.getString('budgetCycle') ?? 'Weekly';
    final daysInPeriod = end.difference(start).inDays + 1;

    double convertedBudget = savedBudget;

    if (savedCycle == 'Weekly' && summaryMode == SummaryMode.monthly) {
      convertedBudget = (savedBudget / 7) * daysInPeriod;
    } else if (savedCycle == 'Monthly' && summaryMode == SummaryMode.weekly) {
      final daysInMonth = DateTime(start.year, start.month + 1, 0).day;
      convertedBudget = (savedBudget / daysInMonth) * daysInPeriod;
    }

    return convertedBudget;
  }
}
