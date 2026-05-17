class SummaryDateUtils {
  static DateTime cleanDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime getStartOfWeek(DateTime date) {
    final cleanDate = SummaryDateUtils.cleanDate(date);
    return cleanDate.subtract(Duration(days: cleanDate.weekday - 1));
  }

  static DateTime getEndOfWeek(DateTime startOfWeek) {
    return startOfWeek.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );
  }

  static DateTime getEndOfMonth(DateTime monthStart) {
    return DateTime(
      monthStart.year,
      monthStart.month + 1,
      0,
      23,
      59,
      59,
    );
  }

  static bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static String formatFullDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  static String formatMonthYear(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
