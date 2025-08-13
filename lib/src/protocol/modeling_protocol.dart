import 'package:equatable/equatable.dart';

abstract class _Decodable<T> extends Equatable {
  /// You should implement this method in order to make the model useable by `performDecodingRequest` method
  T fromJson(dynamic json);
}

/// Grants implementing `fromJson(dynamic json)` to make the conforming Model Class
/// usable as the decodable generic parameter of method `performDecodingRequest`
/// Provides optional mockingData attribute to set the data to use when mocking

abstract class ModelingProtocol extends _Decodable {}
