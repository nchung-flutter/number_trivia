import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/util/input_converter.dart';

void main() {
  InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });

  group("stringToUnsignedInteger", () {
    test('should return a integer', () async {
      final str = '123';
      final result = inputConverter.stringToUnsignedInteger(str);
      expect(result, Right(123));
    });

    test('should return a error', () async {
      final str = '-123';
      final result = inputConverter.stringToUnsignedInteger(str);
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
