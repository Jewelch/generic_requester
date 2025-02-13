import '../protocol/modeling_protocol.dart';

class NoDataModel extends ModelingProtocol {
  final bool? success;

  NoDataModel({this.success});

  @override
  NoDataModel fromJson(dynamic json) => NoDataModel(success: json['success'] as bool);

  @override
  List<Object?> get props => [success];
}
