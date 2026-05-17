import 'package:flutter/material.dart';
import '../builders/designs/colors.dart';
import '../summary_helpers/summary_enums.dart';

class ChartModeToggle extends StatelessWidget {
  final ChartMode selectedMode;
  final ValueChanged<ChartMode> onChanged;

  const ChartModeToggle({
    super.key,
    required this.selectedMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: colorCardBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            _ChartButton(
              icon: Icons.donut_large_rounded,
              selected: selectedMode == ChartMode.pie,
              onTap: () => onChanged(ChartMode.pie),
            ),
            _ChartButton(
              icon: Icons.bar_chart_rounded,
              selected: selectedMode == ChartMode.bar,
              onTap: () => onChanged(ChartMode.bar),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ChartButton({
    required this.icon,
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
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? colorNavy : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: selected ? Colors.white : colorNavy.withOpacity(0.55),
          ),
        ),
      ),
    );
  }
}
