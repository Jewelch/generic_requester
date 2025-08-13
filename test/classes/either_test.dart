import 'package:flutter_test/flutter_test.dart';
import 'package:generic_requester/src/utils/either.dart';

void main() {
  group('Either', () {
    test('Left should hold a value', () {
      final left = Either.left('Error');
      expect(left.isLeft(), true);
      expect(left.fold((l) => l, (r) => r), 'Error');
    });

    test('Right should hold a value', () {
      final right = Either.right(42);
      expect(right.isRight(), true);
      expect(right.fold((l) => l, (r) => r), 42);
    });
  });
}
