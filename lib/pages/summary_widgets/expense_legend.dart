import 'package:flutter/material.dart';
import '../builders/designs/colors.dart';
import '../summary_helpers/category_style.dart';
import '../summary_helpers/category_summary.dart';

class ExpenseLegend extends StatelessWidget {
  final List<CategorySummary> categories;
  final double total;

  const ExpenseLegend({
    super.key,
    required this.categories,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorCardBg.withOpacity(0.65),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expense legend',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: colorNavy,
            ),
          ),
          const SizedBox(height: 10),
          ...categories.map((category) {
            final percentage = total == 0 ? 0 : (category.amount / total) * 100;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: category.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      CategoryStyle.capitalize(category.name),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '₱${category.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
