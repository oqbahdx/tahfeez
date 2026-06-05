enum RecitationType {
  recitation(1),
  review(2);

  final int value;
  const RecitationType(this.value);

  String get displayName {
    switch (this) {
      case RecitationType.recitation:
        return 'Recitation';
      case RecitationType.review:
        return 'Review';
    }
  }

  static RecitationType fromInt(int value) {
    return RecitationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => RecitationType.recitation,
    );
  }
}
