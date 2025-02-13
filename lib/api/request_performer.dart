library;

import 'dart:async';

import 'package:jch_requester/api/extensions/index.dart';

import './exports.dart';
import './utils/pretty_dio_logger.dart';

/// #### A Generic request performer based on a smart Dio Interceptor
class RequestPerformer {
  static final _backgroundTransformer = BackgroundTransformer();

  static void configure(
    BaseOptions baseOptions, {
    QueuedInterceptorsWrapper? interceptor,
    bool debugginActivated = false,
    bool mockingEnabled = false,
  }) {
    _baseOptions = baseOptions;
    _interceptor = interceptor;
    _debugginActivated = debugginActivated;
    _mockingEnabled = mockingEnabled;
  }

  static late BaseOptions _baseOptions;
  static late QueuedInterceptorsWrapper? _interceptor;
  static bool _debugginActivated = false;
  static bool _mockingEnabled = false;

  /// ### A generic method that consumes an API and handles automatic data serialization/mocking
  Future<R?> performDecodingRequest<R, MP extends ModelingProtocol>({
    required MP decodableModel,
    final bool mockIt = false,
    final bool debugIt = true,
    required RestfullMethods method,
    String? baseUrl,
    required String path,
    final dynamic body,
    final Options? options,
    final String? contentType,
    final StringKeyedMap? extraHeaders,
    final StringKeyedMap? queryParameters,
    final CancelToken? cancelToken,
    final ProgressCallback? onSendProgress,
    final ProgressCallback? onReceiveProgress,
  }) async {
    //! Dio definition
    final dio = Dio(RequestPerformer._baseOptions);

    //! Interceptor setup
    dio.interceptors
      ..clear()
      ..addBasedOnCondition(
        condition: !kReleaseMode,
        _interceptor,
      )
      ..addBasedOnCondition(
        condition: _debugginActivated || debugIt,
        PrettyDioLogger.instance,
      );

    dio.transformer = _backgroundTransformer;

    if (_mockingEnabled || mockIt) {
      await Future.delayed(const Duration(milliseconds: 500));
      return decode(
        decodableModel,
        mockingData: decodableModel.mockingData,
        mocking: true,
      ) as R;
    }

    return switch (method) {
      RestfullMethods.get => dio
          .get(
            path,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
          )
          .then((response) => decode(decodableModel, response: response)),
      RestfullMethods.post => dio
          .post(path,
              data: body,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress)
          .then((response) => decode(decodableModel, response: response)),
      RestfullMethods.put => dio
          .put(path,
              data: body,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress)
          .then((response) => decode(decodableModel, response: response)),
      RestfullMethods.patch => dio
          .patch(path,
              data: body,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress)
          .then((response) => decode(decodableModel, response: response)),
      RestfullMethods.delete => dio
          .delete(
            path,
            data: body,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
          )
          .then((response) => decode(decodableModel, response: response))
    };
  }

  dynamic decode<T extends ModelingProtocol>(
    T decodableModel, {
    Response<dynamic>? response,
    dynamic mockingData,
    bool mocking = false,
  }) {
    assert(
      mockingData != null || response != null,
      '\n[RequestPerformer => decode] You should provide either some mocking data or a real response to be trated',
    );

    final data = mockingData ?? response?.data;

    try {
      if (decodableModel is PatchingModel) {
        return decodableModel.fromJson({});
      }

      if (decodableModel is NoDataModel) {
        return decodableModel.fromJson({
          'success': mocking ? true : (data.statusCode >= 200 && data.statusCode < 300),
        });
      }

      assert(data is List || data is StringKeyedMap);
      return decodableModel.fromJson(data);
    } catch (_, __) {
      throw DioException(requestOptions: RequestOptions(path: "Decoding Process Has Failed"));
    }
  }
}
