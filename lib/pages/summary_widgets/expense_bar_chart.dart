import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../builders/designs/colors.dart';
import '../expense_model.dart';
import '../summary_helpers/summary_date_utils.dart';
import '../summary_helpers/summary_enums.dart';

class ExpenseBarChart extends StatelessWidget {
  final List<Expense> expenses;
  final DateTime start;
  final DateTime end;
  final double periodBudget;
  final SummaryMode summaryMode;

  const ExpenseBarChart({
    super.key,
    required this.expenses,
    required this.start,
    required this.end,
    required this.periodBudget,
    required this.summaryMode,
  });

  @override
  Widget build(BuildContext context) {
    final days = <DateTime>[];
    DateTime cursor = DateTime(start.year, start.month, start.day);

    while (!cursor.isAfter(DateTime(end.year, end.month, end.day))) {
      days.add(cursor);
      cursor = cursor.add(const Duration(days: 1));
    }

    final dailyTotals = days.map((day) {
      final dayExpenses = expenses.where((expense) {
        final expenseDate = SummaryDateUtils.cleanDate(expense.date);
        return SummaryDateUtils.isSameDate(expenseDate, day);
      });
      return dayExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
    }).toList();

    final maxDailyTotal = dailyTotals.isEmpty
        ? 0.0
        : dailyTotals.reduce((a, b) => a > b ? a : b);

    final baseMaxY = periodBudget > maxDailyTotal ? periodBudget : maxDailyTotal;
    final chartMaxY = baseMaxY == 0 ? 100.0 : baseMaxY;

    final barGroups = List.generate(days.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: dailyTotals[index],
            width: summaryMode == SummaryMode.weekly ? 18 : 5,
            color: colorNavy,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      );
    });

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          maxY: chartMaxY,
          barGroups: barGroups,
          alignment: BarChartAlignment.spaceAround,
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              if (periodBudget > 0)
                HorizontalLine(
                  y: periodBudget,
                  color: colorNavy.withOpacity(0.35),
                  strokeWidth: 1,
                  dashArray: [6, 4],
                ),
            ],
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: chartMaxY / 4,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: colorDivider, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                interval: chartMaxY / 4,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value >= 1000
                        ? '${(value / 1000).toStringAsFixed(1)}k'
                        : value.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 9,
                      color: colorBodyText,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= days.length) {
                    return const SizedBox.shrink();
                  }

                  if (summaryMode == SummaryMode.weekly) {
                    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        labels[index],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colorBodyText,
                        ),
                      ),
                    );
                  }

                  final day = days[index].day;
                  final lastDay = days.last.day;
                  if (day != 1 && day % 5 != 0 && day != lastDay) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: colorBodyText,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
