import 'package:flutter/material.dart';
import '../../../../theme/tahfeez_theme.dart';

class AttendanceSummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconBgColor;
  final Color? iconColor;
  final Color? valueColor;

  const AttendanceSummaryCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconBgColor,
    this.iconColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TahfeezColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TahfeezColors.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor ?? TahfeezColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor ?? TahfeezColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TahfeezTextStyles.headlineLg.copyWith(
              fontSize: 24,
              color: valueColor ?? TahfeezColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TahfeezTextStyles.labelMd.copyWith(
              color: TahfeezColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
