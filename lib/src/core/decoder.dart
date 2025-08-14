import '../../generic_requester.dart' show ModelingProtocol, Response;
import '../models/patching_model.dart';
import '../utils/either.dart';
import 'errors/exceptions.dart';

mixin GenericResponseDecoder {
  Either<Exception, MP> decode<MP extends ModelingProtocol>(
    MP decodableModel, {
    Response<dynamic>? response,
    dynamic mockingData,
    bool mocking = false,
  }) {
    try {
      if (mockingData == null && response == null) throw NoDataToDecodeException();

      final data = mocking ? mockingData : response?.data;

      if (data is! List && data is! Map<String, dynamic>) throw UnsupportedDataTypeException();

      return Right((decodableModel is NoDataModel)
          ? decodableModel.fromJson(
              {
                'success':
                    mocking ? true : (response!.statusCode! >= 200 && response.statusCode! < 300),
              },
            )
          : decodableModel.fromJson(data));
    } on Exception catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(JsonParsingException(e, s));
    }
  }
}
