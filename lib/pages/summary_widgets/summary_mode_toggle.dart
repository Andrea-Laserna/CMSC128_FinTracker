import 'package:flutter/material.dart';
import '../builders/designs/colors.dart';
import '../summary_helpers/summary_enums.dart';

class SummaryModeToggle extends StatelessWidget {
  final SummaryMode selectedMode;
  final ValueChanged<SummaryMode> onChanged;

  const SummaryModeToggle({
    super.key,
    required this.selectedMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: colorCardBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          _ModeButton(
            label: 'Weekly',
            selected: selectedMode == SummaryMode.weekly,
            onTap: () => onChanged(SummaryMode.weekly),
          ),
          _ModeButton(
            label: 'Monthly',
            selected: selectedMode == SummaryMode.monthly,
            onTap: () => onChanged(SummaryMode.monthly),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? colorNavy : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : colorNavy,
            ),
          ),
        ),
      ),
    );
  }
}
