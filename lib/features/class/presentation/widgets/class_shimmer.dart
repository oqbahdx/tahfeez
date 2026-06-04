import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../theme/tahfeez_theme.dart';

class ClassShimmer extends StatelessWidget {
  final int itemCount;

  const ClassShimmer({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: TahfeezColors.surfaceContainer,
      highlightColor: TahfeezColors.surface,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TahfeezColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 160,
                  height: 18,
                  decoration: BoxDecoration(
                    color: TahfeezColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 24,
                      decoration: BoxDecoration(
                        color: TahfeezColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 80,
                      height: 24,
                      decoration: BoxDecoration(
                        color: TahfeezColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: TahfeezColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 100,
                      height: 14,
                      decoration: BoxDecoration(
                        color: TahfeezColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
