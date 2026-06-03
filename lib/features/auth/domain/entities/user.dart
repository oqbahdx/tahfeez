import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? userName;
  final String email;
  final String? role;
  final bool? isActive;
  final String? fullName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? status;

  const User({
    required this.id,
    this.userName,
    required this.email,
    this.role,
    this.isActive,
    this.fullName,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  @override
  List<Object?> get props => [
    id,
    userName,
    email,
    role,
    isActive,
    fullName,
    createdAt,
    updatedAt,
    status,
  ];
}

class UserRole {
  static const String student = 'Student';
  static const String teacher = 'Teacher';
  static const String assistant = 'Assistant';
  static const String supervisor = 'Supervisor';
  static const String accountant = 'Accountant';
  static const String admin = 'Admin';
}
