part of 'number_trivia_bloc.dart';

@immutable
abstract class NumberTriviaState extends BaseEquatable {
  NumberTriviaState();
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  Loaded(this.trivia);

  @override
  List<Object> get props => [trivia];
}

class Error extends NumberTriviaState {
  final String message;

  Error({this.message});

  @override
  List<Object> get props => [message];
}
