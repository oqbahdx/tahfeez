import 'package:flutter/material.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../../../l10n/app_localizations.dart';

class EmptyClassesWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const EmptyClassesWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.school_outlined,
              size: 80,
              color: TahfeezColors.onSurfaceVariant.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noClassesFound,
              style: TahfeezTextStyles.titleLg.copyWith(
                color: TahfeezColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: Text(l10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
