import 'package:flutter/material.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../../../l10n/app_localizations.dart';

class EmptyRecitationsWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const EmptyRecitationsWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: TahfeezColors.primary.withOpacity(0.04),
                    ),
                  ),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: TahfeezColors.primary.withOpacity(0.07),
                    ),
                  ),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: TahfeezColors.primary.withOpacity(0.10),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      size: 32,
                      color: TahfeezColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noRecitationsFound,
              style: TahfeezTextStyles.titleLg.copyWith(
                color: TahfeezColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noRecitationsFoundSubtitle,
              style: TahfeezTextStyles.bodyMd.copyWith(
                color: TahfeezColors.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: TahfeezColors.primary,
                  foregroundColor: TahfeezColors.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(
                  l10n.retry,
                  style: TahfeezTextStyles.labelLg,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
