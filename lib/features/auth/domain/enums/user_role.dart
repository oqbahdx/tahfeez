enum UserRole {
  admin(1),
  teacher(2),
  student(3),
  parent(4),
  accountant(5),
  supervisor(6),
  assistant(7);

  final int value;
  const UserRole(this.value);

  String get displayName => name[0].toUpperCase() + name.substring(1);

  String get asString => displayName;

  static UserRole fromValue(int value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.student,
    );
  }

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.asString == value,
      orElse: () => UserRole.student,
    );
  }
}
