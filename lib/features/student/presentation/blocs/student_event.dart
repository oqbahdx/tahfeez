import 'package:equatable/equatable.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object?> get props => [];
}

class GetStudentsEvent extends StudentEvent {}

class RefreshStudentsEvent extends StudentEvent {}

class SearchStudentsEvent extends StudentEvent {
  final String query;

  const SearchStudentsEvent(this.query);

  @override
  List<Object?> get props => [query];
}
