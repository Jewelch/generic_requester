import '../protocol/modeling_protocol.dart';

class PatchingModel extends ModelingProtocol {
  final bool? success;

  PatchingModel({this.success});

  @override
  PatchingModel fromJson(dynamic json) => PatchingModel(success: json['success'] as bool);
}
