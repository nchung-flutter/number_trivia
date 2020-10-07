import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia/data/models/number_trivia_model.dart';

import '../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient httpClient;
  NumberTriviaRemoteDataSourceImpl remoteDataSourceImpl;

  setUp(() {
    httpClient = MockHttpClient();
    remoteDataSourceImpl = NumberTriviaRemoteDataSourceImpl(httpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(httpClient.get(any, headers: anyNamed("headers")))
        .thenAnswer((_) async => http.Response(fixture("trivia.json"), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(httpClient.get(any, headers: anyNamed("headers"))).thenAnswer((_) async => http.Response("", 404));
  }

  group("getConcreteNumberTrivia", () {
    final tNumber = 1;

    test("should return NumberTrivia", () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      var result = await remoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
      // assert
      verify(httpClient.get("http://numbersapi.com/$tNumber?json", headers: {'Content-Type': 'application/json'}));

      expect(result, NumberTriviaModel.fromJson(json.decode(fixture("trivia.json"))));
    });

    test("should throw ServerException", () async {
      // arrange
      when(httpClient.get(any, headers: anyNamed("headers"))).thenAnswer((_) async => http.Response("", 404));
      // act
      // assert
      expect(() => remoteDataSourceImpl.getConcreteNumberTrivia(tNumber), throwsA(isInstanceOf<ServerException>()));
    });
  });

  group("getRandomNumberTrivia", () {
    test("should return NumberTrivia", () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      var result = await remoteDataSourceImpl.getRandomNumberTrivia();
      // assert
      verify(httpClient.get("http://numbersapi.com/random?json", headers: {'Content-Type': 'application/json'}));

      expect(result, NumberTriviaModel.fromJson(json.decode(fixture("trivia.json"))));
    });

    test("should throw ServerException", () async {
      setUpMockHttpClientFailure404();
      // assert
      expect(() => remoteDataSourceImpl.getRandomNumberTrivia(), throwsA(isInstanceOf<ServerException>()));
    });
  });
}
