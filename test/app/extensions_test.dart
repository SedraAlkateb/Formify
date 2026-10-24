import 'package:flutter_test/flutter_test.dart';
import 'package:formify/app/extentions.dart';

void main() {
  group('NonNullString.orEmpty', () {
    test('returns empty string for null', () {
      String? s; // Arrange
      final result = s.orEmpty(); // Act
      expect(result, ''); // Assert
    });

    test('returns the value when not null', () {
      String? s = 'abc';
      expect(s.orEmpty(), 'abc');
    });
  });

  group('NonNullInt.orZero', () {
    test('returns 0 for null', () {
      int? i;
      expect(i.orZero(), 0);
    });

    test('returns the value when not null', () {
      int? i = 7;
      expect(i.orZero(), 7);
    });
  });
}
