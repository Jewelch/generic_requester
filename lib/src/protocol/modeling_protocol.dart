import 'package:equatable/equatable.dart' show EquatableMixin;

abstract class _Decodable<T> with EquatableMixin {
  /// You should implement this method in order to make the model useable by `performDecodingRequest` method
  T fromJson(dynamic json);

  @override
  List<Object?> get props => [];
}

mixin _Mockable on _Decodable {
  /// Provide data to be mocked if you want, an exception is thrown if mocking data is neither a Map nor a List
  final dynamic mockingData = {};
}

abstract class _ModelingProtocol extends _Decodable with _Mockable {}

/// Grants implementing `fromJson(dynamic json)` to make the conforming Model Class
/// usable as the decodable generic parameter of method `performDecodingRequest`
/// Provides optional mockingData attribute to set the data to use when mocking
typedef ModelingProtocol = _ModelingProtocol;
