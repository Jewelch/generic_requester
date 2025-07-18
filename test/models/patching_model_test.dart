import 'package:flutter_test/flutter_test.dart';
import 'package:generic_requester/src/models/patching_model.dart';

void main() {
  group('PatchingModel', () {
    test('fromJson should create an instance from JSON', () {
      final model = PatchingModel().fromJson({});
      expect(model, isA<PatchingModel>());
    });
  });
}
