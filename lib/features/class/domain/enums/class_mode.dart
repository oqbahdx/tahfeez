enum ClassMode {
  online(0),
  offline(1);

  final int value;
  const ClassMode(this.value);

  String get displayName {
    switch (this) {
      case ClassMode.online:
        return 'Online';
      case ClassMode.offline:
        return 'Offline';
    }
  }

  static ClassMode fromInt(int value) {
    return ClassMode.values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => ClassMode.online,
    );
  }
}
