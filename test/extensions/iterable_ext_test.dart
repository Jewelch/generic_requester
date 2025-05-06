import 'package:flutter_test/flutter_test.dart';
import 'package:generic_requester/src/extensions/iterable_ext.dart';

void main() {
  group('Iterable Extensions', () {
    test('addBasedOnCondition should add element based on condition', () {
      final list = <int>[];
      list.addBasedOnCondition(1, condition: true);
      expect(list, [1]);
      list.addBasedOnCondition(2, condition: false);
      expect(list, [1]);
    });
  });
}
