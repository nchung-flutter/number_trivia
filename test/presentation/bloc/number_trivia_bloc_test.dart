import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia getConcreteNumberTrivia;
  MockGetRandomNumberTrivia getRandomNumberTrivia;
  MockInputConverter inputConverter;

  setUp(() {
    getConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    getRandomNumberTrivia = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(getConcreteNumberTrivia, getRandomNumberTrivia, inputConverter);
  });
  tearDown(() {
    bloc?.close();
  });

  test('initialState should be Empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group("GetTriviaForConcreteNumber", () {
    final tNumberStr = '1';
    final tNumber = 1;
    final tNumberTrivia = NumberTrivia(text: '1', number: 1);

    setUpMockInputConverterSuccess() {
      when(inputConverter.stringToUnsignedInteger(tNumberStr)).thenAnswer((_) => Right(tNumber));
    }

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        setUpMockInputConverterSuccess();
        bloc.add(GetTriviaForConcreteNumber(tNumberStr));
        await untilCalled(inputConverter.stringToUnsignedInteger(any));
        // assert
        verify(inputConverter.stringToUnsignedInteger(tNumberStr));
      },
    );

    test(
      'Input is invalid',
      () async {
        when(inputConverter.stringToUnsignedInteger(any)).thenReturn(Left(InvalidInputFailure()));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberStr));
        // assert
        expectLater(bloc, emitsInOrder([Error(message: INVALID_INPUT_FAILURE_MESSAGE)]));
      },
    );

    test("Get Success", () async {
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
      bloc.add(GetTriviaForConcreteNumber(tNumberStr));
      // assert
      expectLater(bloc, emitsInOrder([Loading(), Loaded(tNumberTrivia)]));
    });

    test("Server error", () async {
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any)).thenAnswer((_) async => Left(ServerFailure()));
      bloc.add(GetTriviaForConcreteNumber(tNumberStr));
      // assert
      expectLater(bloc, emitsInOrder([Loading(), Error(message: SERVER_FAILURE_MESSAGE)]));
    });
    test("Cache error", () async {
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any)).thenAnswer((_) async => Left(CacheFailure()));
      bloc.add(GetTriviaForConcreteNumber(tNumberStr));
      // assert
      expectLater(bloc, emitsInOrder([Loading(), Error(message: CACHE_FAILURE_MESSAGE)]));
    });
  });

  group("GetTriviaForRandomNumber", () {
    final tNumberTrivia = NumberTrivia(text: '1', number: 1);

    test("Get Trivia from Random Success", () async {
      when(getRandomNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
      bloc.add(GetTriviaForRandomNumber());
      // assert
      expectLater(bloc, emitsInOrder([Loading(), Loaded(tNumberTrivia)]));
    });

    test("Get Trivia from Random Server error", () async {
      when(getRandomNumberTrivia(any)).thenAnswer((_) async => Left(ServerFailure()));
      bloc.add(GetTriviaForRandomNumber());
      // assert
      expectLater(bloc, emitsInOrder([Loading(), Error(message: SERVER_FAILURE_MESSAGE)]));
    });

    test("Get Trivia from Random Cache error", () async {
      when(getRandomNumberTrivia(any)).thenAnswer((_) async => Left(CacheFailure()));
      bloc.add(GetTriviaForRandomNumber());
      // assert
      expectLater(bloc, emitsInOrder([Loading(), Error(message: CACHE_FAILURE_MESSAGE)]));
    });
  });
}
