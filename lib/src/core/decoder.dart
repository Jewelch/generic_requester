import '../../generic_requester.dart'
    show ModelingProtocol, PatchingModel, StringKeyedMap, DioException, RequestOptions, Response;

class GenericResponseDecoder {
  dynamic decode<MP extends ModelingProtocol>(
    MP decodableModel, {
    Response<dynamic>? response,
    dynamic mockingData,
    bool mocking = false,
  }) {
    if (mockingData == null && response == null) {
      throw DioException(
        requestOptions: RequestOptions(path: "Decoding Process Has Failed"),
        message: "You should provide either some mocking data or a real response to be treated",
      );
    }

    final data = mockingData ?? response?.data;

    try {
      if (decodableModel is PatchingModel) {
        return decodableModel.fromJson({
          'success': mocking ? true : (data.statusCode >= 200 && data.statusCode < 300),
        });
      }

      if (data is List || data is StringKeyedMap) {
        return decodableModel.fromJson(data);
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: "Decoding Process Has Failed"),
          message: "Invalid data type",
        );
      }
    } catch (e, stackTrace) {
      throw DioException(
        requestOptions: RequestOptions(path: "Decoding Process Has Failed"),
        message: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }
}
