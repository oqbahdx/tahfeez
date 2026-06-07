import 'package:equatable/equatable.dart';
import '../../domain/entities/recitation.dart';

abstract class RecitationState extends Equatable {
  const RecitationState();
  @override
  List<Object?> get props => [];
}

class RecitationInitial extends RecitationState {}

class RecitationLoading extends RecitationState {}

class RecitationsLoaded extends RecitationState {
  final List<Recitation> recitations;
  final List<Recitation> filteredRecitations;
  final String? selectedMonth;

  const RecitationsLoaded({
    required this.recitations,
    required this.filteredRecitations,
    this.selectedMonth,
  });

  @override
  List<Object?> get props => [recitations, filteredRecitations, selectedMonth];
}

class RecitationOperationLoading extends RecitationState {
  const RecitationOperationLoading();
}

class RecitationOperationSuccess extends RecitationState {
  final String message;
  const RecitationOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class RecitationError extends RecitationState {
  final String message;
  const RecitationError(this.message);
  @override
  List<Object?> get props => [message];
}
