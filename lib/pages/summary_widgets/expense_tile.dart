import 'package:flutter/material.dart';
import '../builders/designs/colors.dart';
import '../summary_helpers/category_style.dart';

class ExpenseTile extends StatelessWidget {
  final Color color;
  final String title;
  final double amount;
  final IconData icon;
  final int transactions;

  const ExpenseTile({
    super.key,
    required this.color,
    required this.title,
    required this.amount,
    required this.icon,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final isCashIn = title.toLowerCase() == 'cash_in';
    final displayTitle = isCashIn ? 'Cash In' : CategoryStyle.capitalize(title);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayTitle,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: colorNavy,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$transactions transaction${transactions == 1 ? '' : 's'}',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorBodyText,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isCashIn ? '+' : '-'}₱${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isCashIn ? Colors.green.shade700 : colorNavy,
            ),
          ),
        ],
      ),
    );
  }
}
