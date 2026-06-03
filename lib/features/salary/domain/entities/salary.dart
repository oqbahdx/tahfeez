import 'package:equatable/equatable.dart';

class Salary extends Equatable {
  final String id;
  final String userId;
  final String? userName;
  final String role;
  final double amount;
  final String status;
  final DateTime salaryMonth;
  final DateTime? paidAt;
  final String? notes;

  const Salary({
    required this.id,
    required this.userId,
    this.userName,
    required this.role,
    required this.amount,
    required this.status,
    required this.salaryMonth,
    this.paidAt,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    role,
    amount,
    status,
    salaryMonth,
    paidAt,
    notes,
  ];
}
