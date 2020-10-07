import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfoImpl;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group("Connected", () {
    test("should return true", () async {
      // arrange
      when(mockDataConnectionChecker.hasConnection).thenAnswer((realInvocation) async => true);
      // act
      var result = await networkInfoImpl.isConnected;
      // assert
      expect(result, true);
    });

    test("should return true", () async {
      // arrange
      when(mockDataConnectionChecker.hasConnection).thenAnswer((realInvocation) async => true);
      // act
      var result = await networkInfoImpl.isConnected;
      // assert
      expect(result, true);
    });

    test("should return true", () async {
      // arrange
      when(mockDataConnectionChecker.hasConnection).thenAnswer((realInvocation) async => true);
      // act
      var result = await networkInfoImpl.isConnected;
      // assert
      expect(result, true);
    });
  });
}
