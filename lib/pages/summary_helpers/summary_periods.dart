import '../expense_model.dart';
import 'summary_date_utils.dart';

class AvailablePeriods {
  final List<DateTime> weeks;
  final List<DateTime> months;

  const AvailablePeriods({
    required this.weeks,
    required this.months,
  });
}

class SummaryPeriods {
  static AvailablePeriods generate(List<Expense> expenses) {
    final now = SummaryDateUtils.cleanDate(DateTime.now());
    DateTime earliestDate = now;

    if (expenses.isNotEmpty) {
      earliestDate = expenses
          .map((e) => SummaryDateUtils.cleanDate(e.date))
          .reduce((a, b) => a.isBefore(b) ? a : b);
    }

    final currentWeekStart = SummaryDateUtils.getStartOfWeek(now);
    final earliestWeekStart = SummaryDateUtils.getStartOfWeek(earliestDate);
    final defaultEarliestWeek =
        currentWeekStart.subtract(const Duration(days: 7 * 11));

    final weekStop = earliestWeekStart.isBefore(defaultEarliestWeek)
        ? earliestWeekStart
        : defaultEarliestWeek;

    final weeks = <DateTime>[];
    DateTime weekCursor = currentWeekStart;

    while (!weekCursor.isBefore(weekStop)) {
      weeks.add(weekCursor);
      weekCursor = weekCursor.subtract(const Duration(days: 7));
    }

    final currentMonthStart = DateTime(now.year, now.month, 1);
    final earliestMonthStart = DateTime(earliestDate.year, earliestDate.month, 1);
    final defaultEarliestMonth =
        DateTime(currentMonthStart.year, currentMonthStart.month - 11, 1);

    final monthStop = earliestMonthStart.isBefore(defaultEarliestMonth)
        ? earliestMonthStart
        : defaultEarliestMonth;

    final months = <DateTime>[];
    DateTime monthCursor = currentMonthStart;

    while (!monthCursor.isBefore(monthStop)) {
      months.add(monthCursor);
      monthCursor = DateTime(monthCursor.year, monthCursor.month - 1, 1);
    }

    return AvailablePeriods(
      weeks: weeks.reversed.toList(),
      months: months.reversed.toList(),
    );
  }
}
