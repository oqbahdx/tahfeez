import 'package:equatable/equatable.dart';

class Subscription extends Equatable {
  final String id;
  final String studentId;
  final String? studentName;
  final double amount;
  final String type;
  final String mode;
  final String paymentMethod;
  final DateTime paymentDate;

  const Subscription({
    required this.id,
    required this.studentId,
    this.studentName,
    required this.amount,
    required this.type,
    required this.mode,
    required this.paymentMethod,
    required this.paymentDate,
  });

  @override
  List<Object?> get props => [
    id,
    studentId,
    studentName,
    amount,
    type,
    mode,
    paymentMethod,
    paymentDate,
  ];
}
