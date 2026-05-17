import 'package:flutter/material.dart';
import '../builders/designs/colors.dart';
import '../summary_helpers/summary_date_utils.dart';
import '../summary_helpers/summary_enums.dart';

class PeriodDropdown extends StatelessWidget {
  final SummaryMode summaryMode;
  final List<DateTime> availableWeeks;
  final List<DateTime> availableMonths;
  final DateTime selectedWeek;
  final DateTime selectedMonth;
  final ValueChanged<DateTime> onChanged;

  const PeriodDropdown({
    super.key,
    required this.summaryMode,
    required this.availableWeeks,
    required this.availableMonths,
    required this.selectedWeek,
    required this.selectedMonth,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final periods = summaryMode == SummaryMode.weekly
        ? availableWeeks
        : availableMonths;

    if (periods.isEmpty) return const SizedBox.shrink();

    final selectedPeriod =
        summaryMode == SummaryMode.weekly ? selectedWeek : selectedMonth;

    final safeValue = periods.any(
      (period) => SummaryDateUtils.isSameDate(period, selectedPeriod),
    )
        ? periods.firstWhere(
            (period) => SummaryDateUtils.isSameDate(period, selectedPeriod),
          )
        : periods.last;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.18),
        ),
      ),
      child: DropdownButton<DateTime>(
        isExpanded: true,
        value: safeValue,
        underline: const SizedBox(),
        icon: Icon(Icons.keyboard_arrow_down, color: colorNavy),
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: colorNavy,
        ),
        items: periods.map((periodStart) {
          final label = summaryMode == SummaryMode.weekly
              ? '${SummaryDateUtils.formatFullDate(periodStart)} - ${SummaryDateUtils.formatFullDate(SummaryDateUtils.getEndOfWeek(periodStart))}'
              : SummaryDateUtils.formatMonthYear(periodStart);

          return DropdownMenuItem<DateTime>(
            value: periodStart,
            child: Text(label),
          );
        }).toList(),
        onChanged: (DateTime? newPeriod) {
          if (newPeriod == null) return;
          onChanged(newPeriod);
        },
      ),
    );
  }
}
