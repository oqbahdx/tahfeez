enum ClassType {
  boys(0),
  girls(1);

  final int value;
  const ClassType(this.value);

  String get displayName {
    switch (this) {
      case ClassType.boys:
        return 'Boys';
      case ClassType.girls:
        return 'Girls';
    }
  }

  static ClassType fromInt(int value) {
    return ClassType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ClassType.boys,
    );
  }
}
