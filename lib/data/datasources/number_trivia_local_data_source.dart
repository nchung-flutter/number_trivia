import 'dart:convert';

import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  static const LAST_NUMBER_TRIVIA = "last_number_trivia";
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel) async {
    if (numberTriviaModel != null)
      sharedPreferences.setString(LAST_NUMBER_TRIVIA, json.encode(numberTriviaModel.toJson()));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    var jsonStr = sharedPreferences.getString(LAST_NUMBER_TRIVIA);
    if (jsonStr == null) {
      throw CacheException();
    } else {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonStr)));
    }
  }
}
