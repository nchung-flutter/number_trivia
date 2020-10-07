import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/domain/repositories/number_trivia_repository.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepository repository;
  NumberTriviaRemoteDataSource mockRemoteDataSource;
  NumberTriviaLocalDataSource mockLocalDataSource;
  NetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
    void runTestsOnline(Function body) {
      group('device is online ', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });
        body();
      });
    }

    void runTestsOffline(Function body) {
      group('device is offline ', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        });
        body();
      });
    }

    group('getConcreteNumberTrivia', () {
      final tNumber = 1;
      final tNumberTriviaModel = NumberTriviaModel(text: 'test', number: tNumber);
      final NumberTrivia tNumberTrivia = tNumberTriviaModel;

      test('should check if the device is online', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        repository.getConcreteNumberTrivia(tNumber);
        verify(mockNetworkInfo.isConnected);
      });

      runTestsOnline(() {
        test('should remote data when call to remote data source is successful', () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          expect(result, equals(Right(tNumberTrivia)));
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        });

        test('should cache data locally when call to remote data source is successful', () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        });

        test('should cache data locally when call to remote data source is unsuccessful', () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async => tNumberTriviaModel);
          // act
          var result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyNoMoreInteractions(mockRemoteDataSource);
          expect(result, equals(Left(ServerFailure())));
        });
      });

      runTestsOffline(() {
        test('should return last locally cached when has cache', () async {
          when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
          // act
          var result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        });

        test('should return last locally cached when no cache', () async {
          when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
          // act
          var result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        });
      });
    });

    group('getRandomNumberTrivia', () {
      final tNumber = 1;
      final tNumberTriviaModel = NumberTriviaModel(text: 'test', number: tNumber);
      final NumberTrivia tNumberTrivia = tNumberTriviaModel;

      test('should check if the device is online', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        repository.getRandomNumberTrivia();
        verify(mockNetworkInfo.isConnected);
      });

      runTestsOnline(() {
        test('should remote data when call to remote data source is successful', () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          expect(result, equals(Right(tNumberTrivia)));
          verify(mockRemoteDataSource.getRandomNumberTrivia());
        });

        test('should cache data locally when call to remote data source is successful', () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        });

        test('should cache data locally when call to remote data source is unsuccessful', () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
          // act
          var result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyNoMoreInteractions(mockRemoteDataSource);
          expect(result, equals(Left(ServerFailure())));
        });
      });

      runTestsOffline(() {
        test('should return last locally cached when has cache', () async {
          when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
          // act
          var result = await repository.getRandomNumberTrivia();
          // assert
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        });

        test('should return last locally cached when no cache', () async {
          when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
          // act
          var result = await repository.getRandomNumberTrivia();
          // assert
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        });
      });
    });
  });
}
