import 'dart:convert';

import 'package:http/http.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final Client client;

  NumberTriviaRemoteDataSourceImpl(this.client);

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) => _geNumberTrivia('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() => _geNumberTrivia('http://numbersapi.com/random');

  Future<NumberTriviaModel> _geNumberTrivia(String url) async {
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body.toString()));
    } else {
      throw ServerException();
    }
  }
}
