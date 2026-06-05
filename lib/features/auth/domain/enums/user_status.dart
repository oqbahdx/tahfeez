enum UserStatus {
  pending(0),
  active(1);

  final int value;
  const UserStatus(this.value);

  String get displayName => name[0].toUpperCase() + name.substring(1);

  bool get isActive => this == UserStatus.active;

  static UserStatus fromValue(int value) {
    return UserStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => UserStatus.pending,
    );
  }
}
