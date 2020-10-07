import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;

  Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => properties;
}

// general failures

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
