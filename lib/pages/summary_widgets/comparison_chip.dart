import 'package:flutter/material.dart';
import '../summary_helpers/summary_enums.dart';

class ComparisonChip extends StatelessWidget {
  final double currentTotal;
  final double previousTotal;
  final SummaryMode summaryMode;

  const ComparisonChip({
    super.key,
    required this.currentTotal,
    required this.previousTotal,
    required this.summaryMode,
  });

  @override
  Widget build(BuildContext context) {
    final previousPeriod =
        summaryMode == SummaryMode.weekly ? 'last week' : 'last month';

    IconData icon;
    Color color;
    String text;

    if (currentTotal == 0 && previousTotal == 0) {
      icon = Icons.info_outline_rounded;
      color = Colors.grey;
      text = 'No expenses this period.';
    } else if (previousTotal == 0) {
      icon = Icons.info_outline_rounded;
      color = Colors.grey;
      text = 'No $previousPeriod data to compare.';
    } else {
      final difference = currentTotal - previousTotal;
      final percentage = (difference.abs() / previousTotal) * 100;

      if (difference > 0) {
        icon = Icons.arrow_upward_rounded;
        color = const Color(0xFFD65A5A);
        text = '${percentage.toStringAsFixed(0)}% higher than $previousPeriod';
      } else if (difference < 0) {
        icon = Icons.arrow_downward_rounded;
        color = const Color(0xFF3E9C6A);
        text = '${percentage.toStringAsFixed(0)}% lower than $previousPeriod';
      } else {
        icon = Icons.remove_rounded;
        color = Colors.grey;
        text = 'Same spending as $previousPeriod';
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
