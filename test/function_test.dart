import 'package:lcov/lcov.dart';
import 'package:test/test.dart';

/// Tests the features of the function coverage.
void main() {
  group('FunctionCoverage', () {
    group('.fromJson()', () {
      test('should return an instance with default values for an empty map', () {
        var coverage = new FunctionCoverage.fromJson(const <String, dynamic>{});
        expect(coverage.data, allOf(isList, isEmpty));
        expect(coverage.found, equals(0));
        expect(coverage.hit, equals(0));
      });

      test('should return an initialized instance for a non-empty map', () {
        var coverage = new FunctionCoverage.fromJson(<String, dynamic>{
          'data': [const {'lineNumber': 127}],
          'found': 3,
          'hit': 19
        });

        expect(coverage.data, allOf(isList, hasLength(1)));
        expect(coverage.data.first, const isInstanceOf<FunctionData>());
        expect(coverage.found, equals(3));
        expect(coverage.hit, equals(19));
      });
    });

    group('.toJson()', () {
      test('should return a map with default values for a newly created instance', () {
        var map = new FunctionCoverage().toJson();
        expect(map, hasLength(3));
        expect(map['data'], allOf(isList, isEmpty));
        expect(map['found'], equals(0));
        expect(map['hit'], equals(0));
      });

      test('should return a non-empty map for an initialized instance', () {
        var map = new FunctionCoverage(3, 19, [new FunctionData('', 0)]).toJson();
        expect(map, hasLength(3));
        expect(map['data'], allOf(isList, hasLength(1)));
        expect(map['data'].first, isMap);
        expect(map['found'], equals(3));
        expect(map['hit'], equals(19));
      });
    });

    group('.toString()', () {
      test(r'should return a format like "FNF:<found>\n,FNH:<hit>"', () {
        expect(new FunctionCoverage().toString(), equals('FNF:0\nFNH:0'));

        var coverage = new FunctionCoverage(3, 19, [new FunctionData('main', 127, executionCount: 3)]);
        expect(coverage.toString(), equals('FN:127,main\nFNDA:3,main\nFNF:3\nFNH:19'));
      });
    });
  });

  group('FunctionData', () {
    group('.fromJson()', () {
      test('should return an instance with default values for an empty map', () {
        var data = new FunctionData.fromJson(const <String, dynamic>{});
        expect(data.executionCount, equals(0));
        expect(data.functionName, isEmpty);
        expect(data.lineNumber, equals(0));
      });

      test('should return an initialized instance for a non-empty map', () {
        var data = new FunctionData.fromJson(const <String, dynamic>{
          'executionCount': 3,
          'functionName': 'main',
          'lineNumber': 127
        });

        expect(data.executionCount, equals(3));
        expect(data.functionName, equals('main'));
        expect(data.lineNumber, equals(127));
      });
    });

    group('.toJson()', () {
      test('should return a map with default values for a newly created instance', () {
        var map = new FunctionData('', 0).toJson();
        expect(map, hasLength(3));
        expect(map['executionCount'], equals(0));
        expect(map['functionName'], isEmpty);
        expect(map['lineNumber'], equals(0));
      });

      test('should return a non-empty map for an initialized instance', () {
        var map = new FunctionData('main', 127, executionCount: 3).toJson();
        expect(map, hasLength(3));
        expect(map['executionCount'], equals(3));
        expect(map['functionName'], equals('main'));
        expect(map['lineNumber'], equals(127));
      });
    });

    group('.toString()', () {
      test('should return a format like "FN:<lineNumber>,<functionName>" when used as definition', () {
        expect(new FunctionData('', 0).toString(asDefinition: true), equals('FN:0,'));
        expect(new FunctionData('main', 127, executionCount: 3).toString(asDefinition: true), equals('FN:127,main'));
      });

      test('should return a format like "FNDA:<executionCount>,<functionName>" when used as data', () {
        expect(new FunctionData('', 0).toString(asDefinition: false), equals('FNDA:0,'));
        expect(new FunctionData('main', 127, executionCount: 3).toString(asDefinition: false), equals('FNDA:3,main'));
      });
    });
  });
}
