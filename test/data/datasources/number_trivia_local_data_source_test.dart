import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../fixtures/fixture_reader.dart';

class MockDataSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockDataSharedPreferences preferences;
  NumberTriviaLocalDataSourceImpl localDataSourceImpl;

  setUp(() {
    preferences = MockDataSharedPreferences();
    localDataSourceImpl = NumberTriviaLocalDataSourceImpl(preferences);
  });

  group("getLastNumberTrivia", () {
    test("should return NumberTrivia", () async {
      // arrange
      when(preferences.getString(any)).thenAnswer((realInvocation) => fixture("trivia.json"));
      // act
      var lastNumberTrivia = await localDataSourceImpl.getLastNumberTrivia();
      // assert
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

      expect(lastNumberTrivia, NumberTriviaModel.fromJson(jsonMap));
    });

    test("should return empty", () async {
      // arrange
      when(preferences.getString(any)).thenReturn(null);
      // assert
      expect(() => localDataSourceImpl.getLastNumberTrivia(), throwsA(isInstanceOf<CacheException>()));
    });
  });
  group("getLastNumberTrivia", () {
    NumberTriviaModel numberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));

    test("should cache NumberTrivia", () async {
      // arrange
      localDataSourceImpl.cacheNumberTrivia(numberTriviaModel);
      // assert
      verify(preferences.setString(
          NumberTriviaLocalDataSourceImpl.LAST_NUMBER_TRIVIA, json.encode(numberTriviaModel.toJson())));
    });

    test("should don't cached", () async {
      // arrange
      localDataSourceImpl.cacheNumberTrivia(null);
      // assert
      verifyNever(preferences.setString(NumberTriviaLocalDataSourceImpl.LAST_NUMBER_TRIVIA, any));
    });
  });
}
