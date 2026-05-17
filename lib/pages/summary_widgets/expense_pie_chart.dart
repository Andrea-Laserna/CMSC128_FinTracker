import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../builders/designs/colors.dart';
import '../summary_helpers/category_summary.dart';

class ExpensePieChart extends StatelessWidget {
  final List<CategorySummary> categories;
  final double total;

  const ExpensePieChart({
    super.key,
    required this.categories,
    required this.total,
  });

  List<PieChartSectionData> _sections() {
    if (categories.isEmpty) {
      return [
        PieChartSectionData(
          color: const Color.fromARGB(255, 54, 59, 72),
          value: 100,
          title: '',
          radius: 86,
        ),
      ];
    }

    return categories.map((category) {
      final percentage = total == 0 ? 0 : (category.amount / total) * 100;

      return PieChartSectionData(
        color: category.color,
        value: category.amount,
        title: percentage < 5 ? '' : '${percentage.toStringAsFixed(0)}%',
        radius: 86,
        titleStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300,
        width: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            PieChart(
              PieChartData(
                sections: _sections(),
                centerSpaceRadius: 72,
                sectionsSpace: 2,
                borderData: FlBorderData(show: false),
              ),
            ),
            SizedBox(
              width: 135,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colorBodyText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '₱${total.toStringAsFixed(2)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: colorNavy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
