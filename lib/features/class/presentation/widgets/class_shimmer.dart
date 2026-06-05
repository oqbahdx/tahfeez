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
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              color: TahfeezColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Accent bar skeleton
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: TahfeezColors.surfaceContainer,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon container skeleton
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: TahfeezColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Text skeleton
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 150,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: TahfeezColors.surfaceContainer,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      width: 68,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: TahfeezColors.surfaceContainer,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 84,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: TahfeezColors.surfaceContainer,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: 90,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: TahfeezColors.surfaceContainer,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}