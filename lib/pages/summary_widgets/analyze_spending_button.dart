import 'package:flutter/material.dart';
import '../builders/designs/colors.dart';

class AnalyzeSpendingButton extends StatelessWidget {
  final bool isAnalyzing;
  final bool isDisabled;
  final VoidCallback onTap;

  const AnalyzeSpendingButton({
    super.key,
    required this.isAnalyzing,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isAnalyzing
              ? colorNavy.withOpacity(0.08)
              : colorNavy.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorNavy.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: isAnalyzing
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorNavy.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Analyzing…',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colorNavy.withOpacity(0.7),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.insights_rounded,
                    size: 17,
                    color: isDisabled
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                        : Theme.of(context).colorScheme.primary.withOpacity(0.75),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Analyze My Spending',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDisabled
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                          : Theme.of(context).colorScheme.primary.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
